import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { getFirestore } from "firebase-admin/firestore";
import { StockCandidate, rankMatches } from "../matching/rankMatches";

// Fetches every verified partner and does a per-partner get() on its
// stock/{bloodGroup} doc (bloodGroup is only ever the doc ID, not a field, so
// a collectionGroup query can't filter on it directly). Fine at the expected
// partner count; if the partner list grows into the hundreds+, replace this
// with a geo-indexed or collectionGroup-based query instead of an all-partners
// fan-out.
async function findStockCandidates(bloodGroup: string): Promise<StockCandidate[]> {
  const db = getFirestore();

  const partnersSnapshot = await db
    .collection("partners")
    .where("verificationStatus", "==", "verified")
    .get();

  const stockDocs = await Promise.all(
    partnersSnapshot.docs.map((partnerDoc) =>
      db.collection("partners").doc(partnerDoc.id).collection("stock").doc(bloodGroup).get(),
    ),
  );

  const candidates: StockCandidate[] = [];
  partnersSnapshot.docs.forEach((partnerDoc, index) => {
    const stockDoc = stockDocs[index];
    const unitCount = stockDoc.exists ? (stockDoc.data()?.unitCount as number | undefined) : undefined;
    if (!unitCount || unitCount <= 0) return;

    const location = partnerDoc.data().location;
    if (!location) return;

    candidates.push({
      partnerId: partnerDoc.id,
      partnerLocation: { latitude: location.latitude, longitude: location.longitude },
      unitCount,
    });
  });

  return candidates;
}

export const onRequestCreated = onDocumentCreated(
  "bloodRequests/{requestId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const request = snapshot.data();
    const bloodGroup = request.bloodGroup as string;
    const location = request.location;

    const candidates = await findStockCandidates(bloodGroup);

    const matchedPartnerIds = rankMatches({
      requestLocation: { latitude: location.latitude, longitude: location.longitude },
      candidates,
    });

    await snapshot.ref.update({
      matchedPartnerIds,
      ...(matchedPartnerIds.length > 0 ? { status: "matched" } : {}),
    });
  },
);
