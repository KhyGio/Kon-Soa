import '../model/password_model.dart';
import '../services/authentication.dart';
import '../services/encryption_service.dart';
import '../services/firestore.dart';

class PasswordRepository {
  final FirestoreService firestore = FirestoreService();

  final EncryptionService encryption = EncryptionService.instance;

  final AuthService auth = AuthService();

  String get _uid {
    final uid = auth.currentUser?.uid;

    if (uid == null) {
      throw StateError('No user is currently logged in.');
    }

    return uid;
  }

  Stream<List<PasswordModel>> getPasswords() {
    return firestore.passwordsStream(_uid).map((snapshot) {
      final List<PasswordModel> items = [];

      for (final document in snapshot.docs) {
        final data = document.data();

        final encryptedTitle = data['encryptedTitle'] as String?;

        final titleIv = data['titleIv'] as String?;

        final encryptedUsername = data['encryptedUsername'] as String?;

        final usernameIv = data['usernameIv'] as String?;

        final encryptionVersion = data['encryptionVersion'];

        // Ignore documents created with the old schema
        // or incomplete encrypted documents.
        if (encryptionVersion != 2 ||
            encryptedTitle == null ||
            encryptedTitle.isEmpty ||
            titleIv == null ||
            titleIv.isEmpty ||
            encryptedUsername == null ||
            encryptedUsername.isEmpty ||
            usernameIv == null ||
            usernameIv.isEmpty) {
          continue;
        }

        try {
          final decryptedTitle = encryption.decrypt(
            cipherText: encryptedTitle,
            iv: titleIv,
          );

          final decryptedUsername = encryption.decrypt(
            cipherText: encryptedUsername,
            iv: usernameIv,
          );

          items.add(
            PasswordModel(
              id: document.id,
              title: decryptedTitle,
              username: decryptedUsername,
            ),
          );
        } catch (_) {
          // Ignore an individual corrupted or
          // incompatible asset without breaking
          // the complete home-screen stream.
          continue;
        }
      }

      return items;
    });
  }

  Future<void> addPassword({
    required String title,
    required String username,
    required String plainPassword,
    String website = '',
  }) async {
    final cleanTitle = title;
    final cleanUsername = username;

    if (cleanTitle.isEmpty) {
      throw ArgumentError('Title is required.');
    }

    if (cleanUsername.isEmpty) {
      throw ArgumentError('Gmail or username is required.');
    }

    if (plainPassword.isEmpty) {
      throw ArgumentError('Password is required.');
    }

    final encryptedTitle = encryption.encrypt(cleanTitle);

    final encryptedUsername = encryption.encrypt(cleanUsername);

    final encryptedPassword = encryption.encrypt(plainPassword);

    await firestore.addPassword(
      uid: _uid,
      encryptedTitle: encryptedTitle,
      encryptedUsername: encryptedUsername,
      encryptedPassword: encryptedPassword,
    );
  }

  Future<String> getDecryptedPassword(String assetId) async {
    if (assetId.isEmpty) {
      throw ArgumentError('Asset ID is missing.');
    }

    final secret = await firestore.getPasswordSecret(
      uid: _uid,
      assetId: assetId,
    );

    if (secret == null) {
      throw StateError('Password credential document was not found.');
    }

    final encryptedPassword = secret['encryptedPassword'] as String?;

    final passwordIv = secret['passwordIv'] as String?;

    if (encryptedPassword == null || encryptedPassword.isEmpty) {
      throw const FormatException('Encrypted password is missing.');
    }

    if (passwordIv == null || passwordIv.isEmpty) {
      throw const FormatException('Password IV is missing.');
    }

    return encryption.decrypt(cipherText: encryptedPassword, iv: passwordIv);
  }

  Future<void> updatePassword({
    required String id,
    required String title,
    required String username,
    required String plainPassword,
  }) async {
    final cleanTitle = title.trim();
    final cleanUsername = username.trim();

    if (id.isEmpty) {
      throw ArgumentError('Asset ID is missing.');
    }

    if (cleanTitle.isEmpty) {
      throw ArgumentError('Title is required.');
    }

    if (cleanUsername.isEmpty) {
      throw ArgumentError('Gmail or username is required.');
    }

    if (plainPassword.isEmpty) {
      throw ArgumentError('Password is required.');
    }

    final encryptedTitle = encryption.encrypt(cleanTitle);

    final encryptedUsername = encryption.encrypt(cleanUsername);

    final encryptedPassword = encryption.encrypt(plainPassword);

    await firestore.updatePassword(
      uid: _uid,
      assetId: id,
      encryptedTitle: encryptedTitle,
      encryptedUsername: encryptedUsername,
      encryptedPassword: encryptedPassword,
    );
  }

  Future<void> deletePassword(String id) {
    if (id.isEmpty) {
      throw ArgumentError('Asset ID is missing.');
    }

    return firestore.deletePassword(uid: _uid, assetId: id);
  }
}
