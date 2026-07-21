import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/password_model.dart';
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

  CollectionReference<Map<String, dynamic>> passwordsCollection(String uid) {
    return userDocument(uid).collection('passwords');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> passwordsStream(String uid) {
    return passwordsCollection(uid).snapshots();
  }

  Future<void> addPassword({
    required String uid,
    required EncryptedField encryptedTitle,
    required EncryptedField encryptedUsername,
    required EncryptedField encryptedPassword,
  }) async {
    await passwordsCollection(uid).add({
      'encryptedTitle': encryptedTitle.encrypText,
      'titleIv': encryptedTitle.ramdomIv,

      'encryptedUsername': encryptedUsername.encrypText,
      'usernameIv': encryptedUsername.ramdomIv,

      'encryptedPassword': encryptedPassword.encrypText,
      'passwordIv': encryptedPassword.ramdomIv,

      'encryptionVersion': 2,
    });
  }

  Future<void> updatePassword({
    required String uid,
    required String assetId,
    required EncryptedField encryptedTitle,
    required EncryptedField encryptedUsername,
    required EncryptedField encryptedPassword,
  }) async {
    await passwordsCollection(uid).doc(assetId).update({
      'encryptedTitle': encryptedTitle.encrypText,
      'titleIv': encryptedTitle.ramdomIv,

      'encryptedUsername': encryptedUsername.encrypText,
      'usernameIv': encryptedUsername.ramdomIv,

      'encryptedPassword': encryptedPassword.encrypText,
      'passwordIv': encryptedPassword.ramdomIv,

      'encryptionVersion': 2,
    });
  }

  Future<Map<String, dynamic>?> getPasswordSecret({
    required String uid,
    required String assetId,
  }) async {
    final snapshot = await passwordsCollection(uid).doc(assetId).get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }

  Future<void> deletePassword({
    required String uid,
    required String assetId,
  }) async {
    await passwordsCollection(uid).doc(assetId).delete();
  }
}
