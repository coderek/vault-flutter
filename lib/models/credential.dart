import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class Credential {
  String username;
  String password;
  String hashedPassword;

  Credential(this.username, this.password, this.hashedPassword);

  @override
  String toString() {
    return '$username, $password, $hashedPassword';
  }
}

class Vault {
  List<Credential> credentials = [];
  String key;

  Vault(this.key);

  void lock() {}
  void open() {}
  void add(Credential cred) {
    cred.hashedPassword = encrypt(cred.password, key);
    credentials.add(cred);
    print('added new cred $cred');
  }
}

String encrypt(String s, String k) {
  final key = Key.fromUtf8(k);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));

  return encrypter.encrypt(s, iv: iv).base64;
}

String decrypt(String s, String k) {
  final key = Key.fromUtf8(k);
  final iv = IV.fromLength(16);
  final encrypted = Encrypted(base64Decode(s));
  final encrypter = Encrypter(AES(key));

  return encrypter.decrypt(encrypted, iv: iv);
}
