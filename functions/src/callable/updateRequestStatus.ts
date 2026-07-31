import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { notifyUsers } from "../notifications/notify";

const ALLOWED_NEW_STATUSES = ["fulfilled", "cancelled"] as const;
type NewStatus = (typeof ALLOWED_NEW_STATUSES)[number];

// A requester may only close out a request that's still actionable — this
// mirrors the same guard the status screen uses to hide the action buttons,
// enforced here too since the client-side check alone can't be trusted.
const TRANSITIONABLE_STATUSES = ["pending", "matched"];

interface UpdateRequestStatusData {
  requestId: string;
  newStatus: NewStatus;
}

export const updateRequestStatus = onCall<UpdateRequestStatusData>(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "You must be signed in to update a request.");
  }

  const { requestId, newStatus } = request.data ?? ({} as UpdateRequestStatusData);
  if (typeof requestId !== "string" || !requestId) {
    throw new HttpsError("invalid-argument", "requestId is required.");
  }
  if (!ALLOWED_NEW_STATUSES.includes(newStatus)) {
    throw new HttpsError("invalid-argument", `newStatus must be one of ${ALLOWED_NEW_STATUSES.join(", ")}.`);
  }

  const db = getFirestore();
  const requestRef = db.collection("bloodRequests").doc(requestId);
  const snapshot = await requestRef.get();

  if (!snapshot.exists) {
    throw new HttpsError("not-found", "Request not found.");
  }

  const data = snapshot.data()!;
  if (data.requesterId !== uid) {
    throw new HttpsError("permission-denied", "You do not own this request.");
  }
  if (!TRANSITIONABLE_STATUSES.includes(data.status)) {
    throw new HttpsError(
      "failed-precondition",
      `Request is already "${data.status}" and can no longer be changed.`,
    );
  }

  await requestRef.update({ status: newStatus });

  const requesterDoc = await db.collection("users").doc(data.requesterId).get();
  const fcmToken = (requesterDoc.data()?.fcmToken as string | undefined) ?? null;

  await notifyUsers(
    [{ userId: data.requesterId, fcmToken }],
    "request_status",
    { requestId, status: newStatus },
    {
      title: "Your blood request update",
      body: `Your request is now ${newStatus}.`,
    },
  );

  return { status: newStatus };
});
