/**
 * One-time script: sets the Firebase Auth custom claim `admin: true` on
 * specific Auth users, by uid.
 *
 * Storage Rules cannot use `isAdmin()`'s Firestore-lookup pattern (a
 * confirmed, still-unexplained bug on this project — see CLAUDE.md §7 and
 * docs/FIREBASE_SETUP.md "Storage rules"), so Storage-side admin checks
 * instead read `request.auth.token.admin == true`, a custom claim on the
 * user's ID token. Firestore rules are UNCHANGED — they still use the
 * Firestore-lookup `isAdmin()` and don't need this claim.
 *
 * There are only ever 2 admin accounts (admin is provisioned internally,
 * never via self-service signup — CLAUDE.md §2), so this is a manually-run
 * script against real Auth users, not an auto-sync Cloud Function trigger.
 * If a 3rd admin is ever added, or an admin account is replaced, THIS
 * SCRIPT MUST BE RE-RUN for that account's uid, or Storage writes will
 * silently fail for them (Firestore-backed admin checks are unaffected,
 * since those don't depend on this claim).
 *
 * Targets the real `bloodlink-dev-wt` project directly via Application
 * Default Credentials — there is no emulator-only mode, since custom
 * claims on emulator users don't reflect anything real.
 *
 * Usage:
 *   cd functions
 *   node scripts/setAdminClaims.js <uid1> [<uid2> ...]
 *
 * Each uid's current custom claims are printed after being set, so the
 * result can be confirmed directly rather than assumed from a lack of error.
 */

const { initializeApp, applicationDefault } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");

const PROJECT_ID = "bloodlink-dev-wt";

const uids = process.argv.slice(2);
if (uids.length === 0) {
  console.error(
    "Usage: node scripts/setAdminClaims.js <uid1> [<uid2> ...]\n" +
      "No uids given — refusing to run."
  );
  process.exit(1);
}

initializeApp({ credential: applicationDefault(), projectId: PROJECT_ID });
const auth = getAuth();

async function main() {
  console.log(`Target project: ${PROJECT_ID}`);

  for (const uid of uids) {
    const before = await auth.getUser(uid); // throws if uid doesn't exist
    console.log(
      `\n${uid} (${before.email || "no email"}) — current claims: ` +
        JSON.stringify(before.customClaims || {})
    );

    await auth.setCustomUserClaims(uid, { admin: true });

    const after = await auth.getUser(uid);
    console.log(
      `${uid} — claims after update: ${JSON.stringify(after.customClaims)}`
    );
  }

  console.log(
    "\nDone. Custom claims only take effect on the client's NEXT ID token " +
      "refresh (re-login, or up to ~1hr token expiry) — a client already " +
      "signed in during this run will not see the new claim until then."
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Failed to set custom claims:", error);
    process.exit(1);
  });
