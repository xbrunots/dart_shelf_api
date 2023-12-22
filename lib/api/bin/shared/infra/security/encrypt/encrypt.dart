import 'package:encrypt/encrypt.dart';

import '../../../../env.dart';

class AppEncrypt {
  AppEncrypt._();

  static final instance = AppEncrypt._();
  final key = Key.fromUtf8(Env.encryptKey);
  final iv = IV.fromLength(16);

  String? encrypt(String plainText) {
    try {
      final enc = Encrypter(AES(key));
      final encrypted = enc.encrypt(plainText, iv: iv);
      return encrypted.base64;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String? decrypt(String encryptedValue) {
    try {
      final enc = Encrypter(AES(key));
      final decrypted = enc.decrypt(Encrypted.fromBase64(encryptedValue), iv: iv);
      return decrypted;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
