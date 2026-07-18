import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';
import '../services/authentication.dart';
import '../services/firestore.dart';

class AuthRepository {
  final AuthService _auth = AuthService();

  final FirestoreService _firestore = FirestoreService();

  User? get currentUser => _auth.currentUser;

  Future<User?> login(String email, String password) {
    return _auth.login(email, password);
  }

  Future<User?> register(
    String fullName,
    String email,
    String masterPassword,
  ) async {
    final user = await _auth.register(email, masterPassword);

    if (user != null) {
      await _firestore.createUser(
        UserModel(uid: user.uid, fullName: fullName, email: email),
      );
    }

    return user;
  }

  Future<void> sendVerification() {
    return _auth.sendVerification();
  }

  Future<bool> isEmailVerified() {
    return _auth.isEmailVerified();
  }

  Future<void> resetPassword(String email) {
    return _auth.resetPassword(email);
  }

  Future<void> logout() {
    return _auth.logout();
  }

  Future<UserModel?> getProfile() async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      return null;
    }

    return _firestore.getUser(uid);
  }
}
