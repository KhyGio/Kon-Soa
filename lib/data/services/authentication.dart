import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;

  Future<User?> login(String email, String password) async {
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  Future<User?> register(String email, String masterPassword) async {
    final result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: masterPassword,
    );

    await result.user?.sendEmailVerification();

    return result.user;
  }

  Future<void> sendVerification() async {
    final user = currentUser;

    if (user == null) {
      throw StateError('No user is currently logged in.');
    }

    await user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    await currentUser?.reload();

    return auth.currentUser?.emailVerified ?? false;
  }

  Future<void> resetPassword(String email) {
    return auth.sendPasswordResetEmail(email: email);
  }

  Future<void> reAuthenticate(String email, String currentPassword) async {
    final user = currentUser;

    if (user == null) {
      throw StateError('No user is currently logged in.');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
  }

  Future<void> logout() {
    return auth.signOut();
  }
}
