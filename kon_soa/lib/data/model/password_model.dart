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
  final String encrypText;
  final String ramdomIv;

  const EncryptedField({required this.encrypText, required this.ramdomIv});
}
