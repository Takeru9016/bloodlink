import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import { logger } from "firebase-functions";

export interface NotificationRecipient {
  userId: string;
  fcmToken: string | null;
}

export interface PushContent {
  title: string;
  body: string;
}

// Distinguishes "this device is gone for good" from a transient send failure
// (rate limit, backend hiccup) so logs don't cry wolf on retryable errors.
// Not wired up to clear `users/{uid}.fcmToken` yet — see CLAUDE.md §7.
const DEAD_TOKEN_ERROR_CODES = new Set([
  "messaging/registration-token-not-registered",
  "messaging/invalid-registration-token",
]);

function toDataPayload(payload: Record<string, unknown>): Record<string, string> {
  const data: Record<string, string> = {};
  for (const [key, value] of Object.entries(payload)) {
    data[key] = String(value);
  }
  return data;
}

// Writes one `notifications` doc per recipient (so the in-app bell icon works
// even without a push token) and sends an FCM push to each recipient that has
// a stored fcmToken. Recipients are deduplicated by caller.
export async function notifyUsers(
  recipients: NotificationRecipient[],
  type: string,
  payload: Record<string, unknown>,
  push: PushContent,
): Promise<void> {
  if (recipients.length === 0) return;

  const db = getFirestore();
  const notificationsRef = db.collection("notifications");
  const batch = db.batch();
  for (const recipient of recipients) {
    batch.set(notificationsRef.doc(), {
      userId: recipient.userId,
      type,
      payload,
      readStatus: false,
      createdAt: FieldValue.serverTimestamp(),
    });
  }
  await batch.commit();

  const pushable = recipients.filter(
    (recipient): recipient is { userId: string; fcmToken: string } => !!recipient.fcmToken,
  );
  if (pushable.length === 0) return;

  const messaging = getMessaging();
  const data = { type, ...toDataPayload(payload) };

  // Sent per-token rather than via sendEachForMulticast: that overload only
  // accepts a token list on its deprecated form (the current one wants
  // Firebase Installation IDs, which this app doesn't capture — it stores
  // classic FCM registration tokens). Fine at expected fan-out sizes (nearby
  // donors for one request); revisit if that ever needs true batching.
  const results = await Promise.allSettled(
    pushable.map((recipient) =>
      messaging.send({
        token: recipient.fcmToken,
        notification: { title: push.title, body: push.body },
        data,
      }),
    ),
  );

  results.forEach((result, index) => {
    if (result.status === "fulfilled") return;
    const { userId } = pushable[index];
    const code = (result.reason as { code?: string } | undefined)?.code;
    if (code && DEAD_TOKEN_ERROR_CODES.has(code)) {
      logger.warn("FCM push failed: dead token", { userId, code });
    } else {
      logger.warn("FCM push failed: transient error", { userId, code });
    }
  });
}
