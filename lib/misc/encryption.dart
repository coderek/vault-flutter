import 'package:encrypt/encrypt.dart' as enc;
import 'dart:convert';

String encrypt(String s, String k) {
  final key = enc.Key.fromUtf8(k);
  final iv = enc.IV.fromLength(16);
  final encrypter = enc.Encrypter(enc.AES(key));

  return encrypter.encrypt(s, iv: iv).base64;
}

String decrypt(String s, String k) {
  final key = enc.Key.fromUtf8(k);
  final iv = enc.IV.fromLength(16);
  final encrypted = enc.Encrypted(base64Decode(s));
  final encrypter = enc.Encrypter(enc.AES(key));

  return encrypter.decrypt(encrypted, iv: iv);
}

