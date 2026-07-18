class AppConstants {
  AppConstants._();

  // Exactly 32 UTF-8 bytes for AES-256.
  //
  // Do not change this value after storing encrypted assets.
  // Changing it will prevent old assets from being decrypted.
  //
  // This key is independent of the user's master password.
  static const String encryptionKey = 'K0nS0a-Shared-Key-2026-32Bytes!!';

  static const String secureKeyName = 'kon_soa_asset_encryption_key';

  static const String usersCollection = 'users';

  static const String passwordsCollection = 'passwords';

  static const String privateCollection = 'private';

  static const String credentialDocument = 'credential';
}
