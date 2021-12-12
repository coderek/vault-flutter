import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:freezed_annotation/freezed_annotation.dart';
import '../misc/logger.dart';

part 'credential.freezed.dart';
part 'credential.g.dart';

var uuid = const Uuid();
var base = 'http://localhost:8000';
// var base = 'https://derekzeng.me'; // prod
var hs = {
  'Authorization': 'Token 41f6bfb5fb56fd082731bf9b8de1a624e973e9de'
  // 'Authorization': 'Token e615966b599918f43f661677f40e139880abb780' // prod
};

@freezed
class Cred with _$Cred {
  factory Cred({
    int? id,
    required String username,
    required String password,
    String? decrypted,
    String? description,
    String? website,
    String? category,
  }) = _Cred;
  factory Cred.fromJson(Map<String, dynamic> json) => _$CredFromJson(json);
}

class Vault extends ChangeNotifier {
  final List<Cred> credentials = [];
  final String secret;

  Vault({required this.secret}) {
    init();
  }

  Future<void> init() async {
    try {
      var response =
          await Dio().get('$base/vault/api/credentials', options: Options(headers: hs));
      for (var c in response.data) {
        credentials.add(Cred.fromJson(c));
      }
      notifyListeners();
    } catch (e) {
      logger.e(e);
    }
  }

  List<String> get categories {
    Set<String> ret = {};
    for (var c in credentials) {
      if (c.category != null) {
        ret.add(c.category!);
      }
    }
    return ret.toList();
  }

  void add(Cred cred) async {
    try {
      var response = await Dio().post('$base/vault/api/credentials',
          data: {
            'key': secret,
            'credential': cred.toJson(),
          },
          options: Options(headers: hs));

      if (response.statusCode == 200) {
        credentials.add(cred);
        notifyListeners();
      } else {
        logger.w('Failed to decrypt password.');
      }
    } catch (e) {
      logger.e(e);
    }
  }

  void remove(Cred cred) async {
    try {
      var id = cred.id!;
      var response = await Dio().delete('$base/vault/api/credentials/$id',
          options: Options(headers: hs));
      if (response.statusCode == 200) {
        credentials.remove(cred);
        notifyListeners();
      } else {
        logger.w('Failed to save');
      }
    } catch (e) {
      logger.e(e);
    }
  }

  void update(Cred old, Cred cred) async {
    try {
      var id = cred.id!;
      if (cred.decrypted == null) {
        var decryptedResponse = await Dio().post('$base/vault/credentials/$id',
            data: {
              'key': secret,
              'credential': cred.toJson(),
            },
            options: Options(headers: hs));
        assert(decryptedResponse.statusCode == 200);
        var decrypted = decryptedResponse.data['s'];
        cred = cred.copyWith(decrypted: decrypted);
      }
      var response = await Dio().put('$base/vault/api/credentials/$id',
          data: {
            'credential': cred.copyWith(password: cred.decrypted!).toJson(),
            'key': secret,
          },
          options: Options(headers: hs));
      if (response.statusCode == 200) {
        var i = credentials.indexOf(old);
        credentials.replaceRange(i, i + 1, [cred]);
        notifyListeners();
      } else {
        logger.w('Failed to save');
      }
    } catch (e) {
      logger.e(e);
    }
  }
}

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
