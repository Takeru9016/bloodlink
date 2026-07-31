import { GeoPointLike, haversineDistanceKm } from "./rankMatches";

export interface DonorCandidate {
  userId: string;
  location: GeoPointLike | null; // null when the donor never captured device location
  optInRadiusKm: number;
  fcmToken: string | null;
}

export interface NearbyDonorMatch {
  userId: string;
  fcmToken: string | null;
}

// Unlike bank matching (one shared MAX_MATCH_DISTANCE_KM), each donor sets
// their own notification radius, so filtering is per-candidate rather than a
// single cutoff.
export function filterNearbyDonors(
  requestLocation: GeoPointLike,
  candidates: DonorCandidate[],
): NearbyDonorMatch[] {
  return candidates
    .filter((candidate) => candidate.location !== null && candidate.optInRadiusKm > 0)
    .filter(
      (candidate) =>
        haversineDistanceKm(requestLocation, candidate.location as GeoPointLike) <=
        candidate.optInRadiusKm,
    )
    .map(({ userId, fcmToken }) => ({ userId, fcmToken }));
}
