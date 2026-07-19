import 'package:encrypt/encrypt.dart';
import '../model/password_model.dart';

class EncryptionService {
  EncryptionService._();

  static final EncryptionService instance = EncryptionService._();

  // 32 characters = AES-256 key
  static const String encryptionKey = '12345678901234567890123456789012';

  late final Key _key = Key.fromUtf8(encryptionKey);

  late final Encrypter encrypter = Encrypter(
    AES(_key, mode: AESMode.cbc, padding: 'PKCS7'),
  );

  EncryptedField encrypt(String plainText) {
    if (plainText.isEmpty) {
      throw ArgumentError('Plaintext cannot be empty.');
    }

    final randomIv = IV.fromSecureRandom(16);

    final encryptedData = encrypter.encrypt(plainText, iv: randomIv);

    return EncryptedField(
      encrypText: encryptedData.base64,
      ramdomIv: randomIv.base64,
    );
  }

  String decrypt({required String encrypText, required String ramdomIv}) {
    if (encrypText.isEmpty) {
      throw const FormatException('Encrypted text is missing.');
    }

    if (ramdomIv.isEmpty) {
      throw const FormatException('Encryption IV is missing.');
    }

    try {
      final storedIv = IV.fromBase64(ramdomIv);

      return encrypter.decrypt64(encrypText, iv: storedIv);
    } catch (e) {
      throw FormatException('Unable to decrypt encrypted data: $e');
    }
  }

  bool canDecrypt({required String encrypText, required String ramdomIv}) {
    try {
      decrypt(encrypText: encrypText, ramdomIv: ramdomIv);
      return true;
    } catch (_) {
      return false;
    }
  }
}
