import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';
import '../services/authentication.dart';
import '../services/firestore.dart';

class AuthRepository {
  final AuthService auth = AuthService();

  final FirestoreService firestore = FirestoreService();

  User? get currentUser => auth.currentUser;

  Future<User?> login(String email, String password) {
    return auth.login(email, password);
  }

  Future<User?> register(
    String fullName,
    String email,
    String masterPassword,
  ) async {
    final user = await auth.register(email, masterPassword);

    if (user != null) {
      await firestore.createUser(
        UserModel(uid: user.uid, fullName: fullName, email: email),
      );
    }

    return user;
  }

  Future<void> sendVerification() {
    return auth.sendVerification();
  }

  Future<bool> isEmailVerified() {
    return auth.isEmailVerified();
  }

  Future<void> resetPassword(String email) {
    return auth.resetPassword(email);
  }

  Future<void> logout() {
    return auth.logout();
  }

  Future<UserModel?> getProfile() async {
    final uid = auth.currentUser?.uid;

    if (uid == null) {
      return null;
    }

    return firestore.getUser(uid);
  }
}
