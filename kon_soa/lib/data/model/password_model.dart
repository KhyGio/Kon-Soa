class PasswordModel {
  final String id;
  final String title;
  final String username;

  const PasswordModel({
    required this.id,
    required this.title,
    required this.username,
  });
}

class EncryptedField {
  final String cipherText;
  final String iv;

  const EncryptedField({required this.cipherText, required this.iv});
}
