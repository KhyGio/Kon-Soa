import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';
import '../model/password_model.dart';
import '../../utils/app_constants.dart';

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

  // Password asset collection under each user document.
  CollectionReference<Map<String, dynamic>> _passwordsCollection(String uid) {
    return userDocument(uid).collection(AppConstants.passwordsCollection);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> passwordsStream(String uid) {
    return _passwordsCollection(uid).snapshots();
  }

  Future<void> addPassword({
    required String uid,
    required EncryptedField encryptedTitle,
    required EncryptedField encryptedUsername,
    required EncryptedField encryptedPassword,
    String website = '',
  }) async {
    final docRef = _passwordsCollection(uid).doc();

    await docRef.set({
      'encryptedTitle': encryptedTitle.cipherText,
      'titleIv': encryptedTitle.iv,
      'encryptedUsername': encryptedUsername.cipherText,
      'usernameIv': encryptedUsername.iv,
      'encryptionVersion': 2,
      'website': website,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Store the secret in a private sub-collection/ document.
    await docRef
        .collection(AppConstants.privateCollection)
        .doc(AppConstants.credentialDocument)
        .set({
          'encryptedPassword': encryptedPassword.cipherText,
          'passwordIv': encryptedPassword.iv,
          'encryptionVersion': 2,
        });
  }

  Future<Map<String, dynamic>?> getPasswordSecret({
    required String uid,
    required String assetId,
  }) async {
    final snap = await _passwordsCollection(uid)
        .doc(assetId)
        .collection(AppConstants.privateCollection)
        .doc(AppConstants.credentialDocument)
        .get();

    return snap.exists ? snap.data() : null;
  }

  Future<void> updatePassword({
    required String uid,
    required String assetId,
    required EncryptedField encryptedTitle,
    required EncryptedField encryptedUsername,
    required EncryptedField encryptedPassword,
  }) async {
    final docRef = _passwordsCollection(uid).doc(assetId);

    await docRef.update({
      'encryptedTitle': encryptedTitle.cipherText,
      'titleIv': encryptedTitle.iv,
      'encryptedUsername': encryptedUsername.cipherText,
      'usernameIv': encryptedUsername.iv,
      'encryptionVersion': 2,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await docRef
        .collection(AppConstants.privateCollection)
        .doc(AppConstants.credentialDocument)
        .update({
          'encryptedPassword': encryptedPassword.cipherText,
          'passwordIv': encryptedPassword.iv,
          'encryptionVersion': 2,
        });
  }

  Future<void> deletePassword({
    required String uid,
    required String assetId,
  }) async {
    final docRef = _passwordsCollection(uid).doc(assetId);

    // Delete private credential document first.
    final credRef = docRef
        .collection(AppConstants.privateCollection)
        .doc(AppConstants.credentialDocument);
    await credRef.delete();

    // Then delete the parent document.
    await docRef.delete();
  }
}
