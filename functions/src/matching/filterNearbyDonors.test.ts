import { DonorCandidate, filterNearbyDonors } from "./filterNearbyDonors";

describe("filterNearbyDonors", () => {
  const requestLocation = { latitude: 0, longitude: 0 };

  function donor(overrides: Partial<DonorCandidate>): DonorCandidate {
    return {
      userId: "donor",
      location: { latitude: 0.05, longitude: 0 },
      optInRadiusKm: 10,
      fcmToken: "token",
      ...overrides,
    };
  }

  it("includes a donor within their own opt-in radius", () => {
    const near = donor({ userId: "near", location: { latitude: 0.01, longitude: 0 }, optInRadiusKm: 5 });
    expect(filterNearbyDonors(requestLocation, [near])).toEqual([
      { userId: "near", fcmToken: "token" },
    ]);
  });

  it("excludes a donor outside their own opt-in radius", () => {
    const far = donor({ userId: "far", location: { latitude: 5, longitude: 0 }, optInRadiusKm: 5 });
    expect(filterNearbyDonors(requestLocation, [far])).toEqual([]);
  });

  it("uses each donor's own radius rather than a shared cutoff", () => {
    const generous = donor({
      userId: "generous",
      location: { latitude: 0.5, longitude: 0 },
      optInRadiusKm: 100,
    });
    const strict = donor({
      userId: "strict",
      location: { latitude: 0.5, longitude: 0 },
      optInRadiusKm: 1,
    });
    expect(filterNearbyDonors(requestLocation, [generous, strict])).toEqual([
      { userId: "generous", fcmToken: "token" },
    ]);
  });

  it("excludes a donor with no captured location", () => {
    const noLocation = donor({ userId: "no-location", location: null });
    expect(filterNearbyDonors(requestLocation, [noLocation])).toEqual([]);
  });

  it("excludes a donor with a zero or missing opt-in radius", () => {
    const zeroRadius = donor({ userId: "zero-radius", optInRadiusKm: 0 });
    expect(filterNearbyDonors(requestLocation, [zeroRadius])).toEqual([]);
  });

  it("carries a null fcmToken through so the caller can still write the notification doc", () => {
    const noToken = donor({ userId: "no-token", fcmToken: null });
    expect(filterNearbyDonors(requestLocation, [noToken])).toEqual([
      { userId: "no-token", fcmToken: null },
    ]);
  });
});
