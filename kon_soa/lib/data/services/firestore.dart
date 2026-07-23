import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/asset_model.dart';
import '../model/user_model.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> userDocument(String uid) {
    return firestore.collection('users').doc(uid);
  }

  Future<void> createUser(UserModel user) async {
    await userDocument(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final snapshot = await userDocument(uid).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return UserModel.fromMap(snapshot.data()!, uid: uid);
  }

  Future<void> updateUser(
    String uid, {
    required String fullName,
    required String email,
  }) async {
    await userDocument(uid).update({'fullName': fullName, 'email': email});
  }

  Future<void> deleteUser(String uid) async {
    await userDocument(uid).delete();
  }

  CollectionReference<Map<String, dynamic>> assetsCollection(String uid) {
    return userDocument(uid).collection('assets');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> assetsStream(String uid) {
    return assetsCollection(uid).snapshots();
  }

  Future<void> addAsset({
    required String uid,
    required EncryptedField encryptedTitle,
    required EncryptedField encryptedUsername,
    required EncryptedField encryptedPassword,
  }) async {
    await assetsCollection(uid).add({
      'encryptedTitle': encryptedTitle.encrypText,
      'titleIv': encryptedTitle.ramdomIv,

      'encryptedUsername': encryptedUsername.encrypText,
      'usernameIv': encryptedUsername.ramdomIv,

      'encryptedPassword': encryptedPassword.encrypText,
      'passwordIv': encryptedPassword.ramdomIv,
    });
  }

  Future<void> updateAsset({
    required String uid,
    required String assetId,
    required EncryptedField encryptedTitle,
    required EncryptedField encryptedUsername,
    required EncryptedField encryptedPassword,
  }) async {
    await assetsCollection(uid).doc(assetId).update({
      'encryptedTitle': encryptedTitle.encrypText,
      'titleIv': encryptedTitle.ramdomIv,

      'encryptedUsername': encryptedUsername.encrypText,
      'usernameIv': encryptedUsername.ramdomIv,

      'encryptedPassword': encryptedPassword.encrypText,
      'passwordIv': encryptedPassword.ramdomIv,
    });
  }

  Future<Map<String, dynamic>?> getAssetSecret({
    required String uid,
    required String assetId,
  }) async {
    final snapshot = await assetsCollection(uid).doc(assetId).get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }

  Future<void> deleteAsset({
    required String uid,
    required String assetId,
  }) async {
    await assetsCollection(uid).doc(assetId).delete();
  }
}
