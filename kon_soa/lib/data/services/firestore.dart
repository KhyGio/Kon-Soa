import 'package:cloud_firestore/cloud_firestore.dart';

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
}
