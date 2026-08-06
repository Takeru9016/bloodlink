/**
 * One-time backfill: sets `updatedBy` on existing `bannerItems` docs that
 * predate the field (4B-8 — CLAUDE.md §5 admin-write attribution).
 *
 * `BannerItemModel` never wrote `updatedBy` before this task, so no doc has
 * a real "last admin who touched this" record. `createdBy` is the only
 * attribution data that ever existed — and for both live banners,
 * `updatedAt` is identical to their creation instant, confirming neither
 * has ever been touched by `updateBanner`/`setActive`/`setDisplayOrder`
 * since creation. So `updatedBy = createdBy` is factually correct here,
 * not a guess. Only backfills docs missing the field; safe to re-run.
 *
 * Targets the real `bloodlink-dev-wt` project via Application Default
 * Credentials, same pattern as scripts/setAdminClaims.js.
 *
 * Usage:
 *   cd functions
 *   node scripts/backfillBannerUpdatedBy.js
 */

const { initializeApp, applicationDefault } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

initializeApp({
  credential: applicationDefault(),
  projectId: "bloodlink-dev-wt",
});
const db = getFirestore();

async function main() {
  const snapshot = await db.collection("bannerItems").get();
  if (snapshot.empty) {
    console.log("No bannerItems docs found.");
    return;
  }

  for (const doc of snapshot.docs) {
    const data = doc.data();
    if (data.updatedBy) {
      console.log(`${doc.id}: already has updatedBy (${data.updatedBy}), skipping`);
      continue;
    }
    if (!data.createdBy) {
      console.warn(`${doc.id}: no createdBy to backfill from — skipping, needs manual review`);
      continue;
    }
    await doc.ref.update({ updatedBy: data.createdBy });
    console.log(`${doc.id}: backfilled updatedBy = ${data.createdBy}`);
  }
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
