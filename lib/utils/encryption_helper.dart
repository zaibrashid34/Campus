import 'package:encrypt/encrypt.dart' as encrypt_lib;

class EncryptionHelper {
  // 32-character key for AES-256
  static final encrypt_lib.Key _key = encrypt_lib.Key.fromUtf8('campus_bites_secure_key_32_bytes!');
  // 16-byte IV (Initialization Vector)
  static final encrypt_lib.IV _iv = encrypt_lib.IV.fromLength(16);

  static final encrypt_lib.Encrypter _encrypter =
      encrypt_lib.Encrypter(encrypt_lib.AES(_key, mode: encrypt_lib.AESMode.cbc));

  /// Encrypts plain text before storing in database / Firestore
  static String encryptData(String plainText) {
    if (plainText.isEmpty) return plainText;
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      // Fallback if encryption fails
      return plainText;
    }
  }

  /// Decrypts encrypted base64 string retrieved from database / Firestore
  static String decryptData(String encryptedText) {
    if (encryptedText.isEmpty) return encryptedText;
    try {
      final encrypted = encrypt_lib.Encrypted.fromBase64(encryptedText);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      // Fallback if decryption fails (e.g., if plain text was stored)
      return encryptedText;
    }
  }
}
