import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { getFirestore } from "firebase-admin/firestore";
import { StockCandidate, rankMatches } from "../matching/rankMatches";
import { DonorCandidate, filterNearbyDonors } from "../matching/filterNearbyDonors";
import { notifyUsers } from "../notifications/notify";

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

// Same all-verified-donors fan-out shape as findStockCandidates above: one
// donorProfiles query (equality-only, no composite index needed) plus a
// per-donor users/{uid} get() for location + fcmToken (donorProfiles has
// neither). Fine at expected donor counts; revisit if that ever changes.
async function findDonorCandidates(
  bloodGroup: string,
  excludeUserId: string,
): Promise<DonorCandidate[]> {
  const db = getFirestore();

  const donorProfilesSnapshot = await db
    .collection("donorProfiles")
    .where("verificationStatus", "==", "verified")
    .where("bloodGroup", "==", bloodGroup)
    .get();

  const profileDocs = donorProfilesSnapshot.docs.filter((doc) => doc.id !== excludeUserId);
  if (profileDocs.length === 0) return [];

  const userDocs = await Promise.all(
    profileDocs.map((doc) => db.collection("users").doc(doc.id).get()),
  );

  return profileDocs.map((profileDoc, index) => {
    const userDoc = userDocs[index];
    const userData = userDoc.exists ? userDoc.data() : undefined;
    const location = userData?.location;

    return {
      userId: profileDoc.id,
      location: location ? { latitude: location.latitude, longitude: location.longitude } : null,
      optInRadiusKm: (profileDoc.data().optInRadiusKm as number | undefined) ?? 0,
      fcmToken: (userData?.fcmToken as string | undefined) ?? null,
    };
  });
}

export const onRequestCreated = onDocumentCreated(
  "bloodRequests/{requestId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const request = snapshot.data();
    const bloodGroup = request.bloodGroup as string;
    const requestLocation = {
      latitude: request.location.latitude,
      longitude: request.location.longitude,
    };

    const candidates = await findStockCandidates(bloodGroup);

    const matchedPartnerIds = rankMatches({
      requestLocation,
      candidates,
    });

    await snapshot.ref.update({
      matchedPartnerIds,
      ...(matchedPartnerIds.length > 0 ? { status: "matched" } : {}),
    });

    const donorCandidates = await findDonorCandidates(bloodGroup, request.requesterId as string);
    const nearbyDonors = filterNearbyDonors(requestLocation, donorCandidates);

    await notifyUsers(
      nearbyDonors,
      "request_nearby",
      {
        requestId: event.params.requestId,
        bloodGroup,
        hospital: request.hospital,
        urgencyWindow: request.urgencyWindow,
      },
      {
        title: "Blood needed nearby",
        body: `${bloodGroup} needed at ${request.hospital}`,
      },
    );
  },
);
