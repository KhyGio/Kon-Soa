import 'package:encrypt/encrypt.dart';

import '../model/password_model.dart';
import '../../utils/app_constants.dart';

class EncryptionService {
  EncryptionService._();

  static final EncryptionService instance = EncryptionService._();

  late final Key _key = Key.fromUtf8(AppConstants.encryptionKey);

  late final Encrypter encrypter = Encrypter(
    AES(_key, mode: AESMode.cbc, padding: 'PKCS7'),
  );

  EncryptedField encrypt(String plainText) {
    if (plainText.isEmpty) {
      throw ArgumentError('Plaintext cannot be empty.');
    }

    final IV randomIv = IV.fromSecureRandom(16);

    final Encrypted encryptedData = encrypter.encrypt(plainText, iv: randomIv);

    return EncryptedField(
      cipherText: encryptedData.base64,
      iv: randomIv.base64,
    );
  }

  String decrypt({required String cipherText, required String iv}) {
    if (cipherText.isEmpty) {
      throw const FormatException('Encrypted text is missing.');
    }

    if (iv.isEmpty) {
      throw const FormatException('Encryption IV is missing.');
    }

    try {
      final IV storedIv = IV.fromBase64(iv);

      final String plainText = encrypter.decrypt64(cipherText, iv: storedIv);

      return plainText;
    } catch (error) {
      throw FormatException('Unable to decrypt encrypted data: $error');
    }
  }

  bool canDecrypt({required String cipherText, required String iv}) {
    try {
      decrypt(cipherText: cipherText, iv: iv);

      return true;
    } catch (_) {
      return false;
    }
  }
}
