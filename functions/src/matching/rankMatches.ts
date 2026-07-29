export interface GeoPointLike {
  latitude: number;
  longitude: number;
}

export interface StockCandidate {
  partnerId: string;
  partnerLocation: GeoPointLike;
  unitCount: number;
}

export interface RankMatchesInput {
  requestLocation: GeoPointLike;
  candidates: StockCandidate[];
}

const EARTH_RADIUS_KM = 6371;

// Beyond this, a bank isn't a realistic option for an urgent request — excluded
// outright rather than just down-ranked, so "matched" always means "reachable."
export const MAX_MATCH_DISTANCE_KM = 50;

// Ranking weights: distance dominates (proximity matters most for an urgent
// request) but stock level breaks ties and nudges rank when distances are close.
const DISTANCE_WEIGHT = 0.7;
const STOCK_WEIGHT = 0.3;

// Units beyond this don't make a bank meaningfully "more matched" — caps the
// stock component so one very well-stocked bank doesn't dominate purely on units.
const STOCK_NORMALIZATION_CAP = 20;

// Cap on how many ranked partner IDs get written back to the request.
export const MAX_MATCHED_PARTNERS = 10;

function toRadians(degrees: number): number {
  return (degrees * Math.PI) / 180;
}

export function haversineDistanceKm(a: GeoPointLike, b: GeoPointLike): number {
  const dLat = toRadians(b.latitude - a.latitude);
  const dLon = toRadians(b.longitude - a.longitude);
  const lat1 = toRadians(a.latitude);
  const lat2 = toRadians(b.latitude);

  const h =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon / 2) ** 2;

  return 2 * EARTH_RADIUS_KM * Math.asin(Math.sqrt(h));
}

// Ranking formula:
//   distanceScore = 1 / (1 + distanceKm)   -> closer partner scores nearer to 1
//   stockScore     = min(unitCount, STOCK_NORMALIZATION_CAP) / STOCK_NORMALIZATION_CAP
//   score          = DISTANCE_WEIGHT * distanceScore + STOCK_WEIGHT * stockScore
// Candidates beyond MAX_MATCH_DISTANCE_KM are excluded before scoring, not just
// down-ranked. Ties are broken by higher unitCount, then partnerId for determinism.
export function rankMatches(input: RankMatchesInput): string[] {
  const scored = input.candidates
    .map((candidate) => ({
      candidate,
      distanceKm: haversineDistanceKm(input.requestLocation, candidate.partnerLocation),
    }))
    .filter(({ distanceKm }) => distanceKm <= MAX_MATCH_DISTANCE_KM)
    .map(({ candidate, distanceKm }) => {
      const distanceScore = 1 / (1 + distanceKm);
      const stockScore =
        Math.min(candidate.unitCount, STOCK_NORMALIZATION_CAP) / STOCK_NORMALIZATION_CAP;
      const score = DISTANCE_WEIGHT * distanceScore + STOCK_WEIGHT * stockScore;
      return { candidate, score };
    });

  scored.sort((a, b) => {
    if (b.score !== a.score) return b.score - a.score;
    if (b.candidate.unitCount !== a.candidate.unitCount) {
      return b.candidate.unitCount - a.candidate.unitCount;
    }
    return a.candidate.partnerId.localeCompare(b.candidate.partnerId);
  });

  return scored.slice(0, MAX_MATCHED_PARTNERS).map(({ candidate }) => candidate.partnerId);
}
