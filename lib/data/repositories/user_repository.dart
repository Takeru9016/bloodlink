import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_model.dart';

part 'user_repository.g.dart';

class UserRepository {
  UserRepository(FirebaseFirestore firestore)
    : _users = firestore
          .collection('users')
          .withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );

  final CollectionReference<UserModel> _users;

  Future<UserModel?> getUser(String uid) async {
    final snapshot = await _users.doc(uid).get();
    return snapshot.data();
  }

  Future<void> createUser(String uid, UserModel user) {
    return _users.doc(uid).set(user);
  }

  Future<void> updateRoles(String uid, List<String> roles) {
    return _users.doc(uid).update({'roles': roles});
  }

  Future<void> updateFcmToken(String uid, String token) {
    return _users.doc(uid).update({'fcmToken': token});
  }

  /// Device-location capture and manual-entry fallback are mutually
  /// exclusive — pass only one of [location]/[city], the other stays null.
  Future<void> updateLocation(String uid, {GeoPoint? location, String? city}) {
    return _users.doc(uid).update({'location': location, 'city': city});
  }

  Stream<UserModel?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((snapshot) => snapshot.data());
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository(FirebaseFirestore.instance);
}
