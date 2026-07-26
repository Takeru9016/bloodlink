Scaffold a Firestore-backed data model.

Given a collection name (e.g. "bloodRequests"):
1. Look up the exact schema in `docs/DATA_MODEL.md` — this is the source of truth. If the collection isn't documented there, stop and ask rather than guessing fields or types.
2. Create a Dart model class under `lib/data/models/` using `freezed` + `json_serializable` for immutability and JSON (de)serialization.
3. Create or extend the matching repository under `lib/data/repositories/` with typed read/write methods. No raw `FirebaseFirestore.instance.collection(...)` calls anywhere outside this layer.
4. If the collection has admin-only write fields (per the security rules section of `docs/FIREBASE_SETUP.md`), enforce that in the repository method too — don't rely on Firestore rules alone.
5. If building this model reveals a field `docs/DATA_MODEL.md` missed, update that file in the same change — don't let docs and code drift apart.
6. Run `flutter pub run build_runner build --delete-conflicting-outputs` after adding the freezed/json_serializable annotations.
