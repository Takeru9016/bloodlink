import {
  MAX_MATCHED_PARTNERS,
  MAX_MATCH_DISTANCE_KM,
  haversineDistanceKm,
  rankMatches,
} from "./rankMatches";

describe("haversineDistanceKm", () => {
  it("returns 0 for identical points", () => {
    const point = { latitude: 12.9716, longitude: 77.5946 };
    expect(haversineDistanceKm(point, point)).toBeCloseTo(0, 5);
  });

  it("computes a known distance (Bengaluru to Mysuru, ~120km)", () => {
    const bengaluru = { latitude: 12.9716, longitude: 77.5946 };
    const mysuru = { latitude: 12.2958, longitude: 76.6394 };
    const distance = haversineDistanceKm(bengaluru, mysuru);
    expect(distance).toBeGreaterThan(100);
    expect(distance).toBeLessThan(140);
  });
});

describe("rankMatches", () => {
  const requestLocation = { latitude: 0, longitude: 0 };

  it("excludes candidates beyond MAX_MATCH_DISTANCE_KM entirely", () => {
    const nearby = {
      partnerId: "near",
      partnerLocation: { latitude: 0.05, longitude: 0 },
      unitCount: 1,
    };
    const farAway = {
      partnerId: "far",
      partnerLocation: { latitude: 10, longitude: 0 },
      unitCount: 100,
    };
    expect(haversineDistanceKm(requestLocation, farAway.partnerLocation)).toBeGreaterThan(
      MAX_MATCH_DISTANCE_KM,
    );

    const result = rankMatches({ requestLocation, candidates: [nearby, farAway] });

    expect(result).toEqual(["near"]);
  });

  it("ranks a closer partner above a farther one with similar stock", () => {
    const close = {
      partnerId: "close",
      partnerLocation: { latitude: 0.01, longitude: 0 },
      unitCount: 5,
    };
    const far = {
      partnerId: "far",
      partnerLocation: { latitude: 0.3, longitude: 0 },
      unitCount: 5,
    };

    const result = rankMatches({ requestLocation, candidates: [close, far] });

    expect(result).toEqual(["close", "far"]);
  });

  it("lets higher stock outrank a slightly farther partner when distances are close", () => {
    const wellStocked = {
      partnerId: "well-stocked",
      partnerLocation: { latitude: 0.05, longitude: 0 },
      unitCount: 20,
    };
    const lowStock = {
      partnerId: "low-stock",
      partnerLocation: { latitude: 0.04, longitude: 0 },
      unitCount: 1,
    };

    const result = rankMatches({ requestLocation, candidates: [wellStocked, lowStock] });

    expect(result).toEqual(["well-stocked", "low-stock"]);
  });

  it("breaks ties by unitCount desc, then partnerId asc", () => {
    const a = {
      partnerId: "b-partner",
      partnerLocation: { latitude: 0.05, longitude: 0 },
      unitCount: 3,
    };
    const b = {
      partnerId: "a-partner",
      partnerLocation: { latitude: 0.05, longitude: 0 },
      unitCount: 3,
    };

    const result = rankMatches({ requestLocation, candidates: [a, b] });

    expect(result).toEqual(["a-partner", "b-partner"]);
  });

  it("caps the result at MAX_MATCHED_PARTNERS", () => {
    const candidates = Array.from({ length: MAX_MATCHED_PARTNERS + 5 }, (_, i) => ({
      partnerId: `partner-${i}`,
      partnerLocation: { latitude: 0.001 * i, longitude: 0 },
      unitCount: 5,
    }));

    const result = rankMatches({ requestLocation, candidates });

    expect(result).toHaveLength(MAX_MATCHED_PARTNERS);
  });

  it("returns an empty array when there are no candidates within range", () => {
    expect(rankMatches({ requestLocation, candidates: [] })).toEqual([]);
  });
});
