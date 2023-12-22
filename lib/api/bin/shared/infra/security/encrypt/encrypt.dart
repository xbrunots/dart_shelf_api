import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

import '../../../../env.dart';

class AppEncrypt {
  AppEncrypt._();

  static final instance = AppEncrypt._();
  final iv = IV.fromLength(16);
  final enc = Encrypter(AES(Key.fromUtf8(Env.encryptKey)));

  dynamic digest(String plainText) {
    try {
      var bytes = utf8.encode(plainText);
      var digest = sha1.convert(bytes);
      return digest;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String? decrypt(String encryptedValue) {
    try {
      return enc.decrypt(Encrypted.fromBase16(encryptedValue), iv: iv);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
