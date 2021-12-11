import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'credential.freezed.dart';
part 'credential.g.dart';

var uuid = const Uuid();

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

class Credential {
  late String id;
  String username;
  String? description;
  String? url;
  String? category;
  String? password;
  String? hashedPassword;

  Credential(
      {required this.username,
      required this.password,
      this.description,
      this.category,
      this.url,
      this.hashedPassword}) {
    id = uuid.v4();
  }

  @override
  String toString() {
    return '$username, $password, $hashedPassword';
  }

  Credential.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        url = json['url'],
        category = json['category'],
        description = json['description'],
        hashedPassword = json['hashedPassword'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'url': url,
        'description': description,
        'category': category,
        'hashedPassword': hashedPassword,
      };
}

class Vault extends ChangeNotifier {
  final List<Cred> credentials = [];
  final String secret;

  Vault({required this.secret}) {
    init();
  }

  Future<void> init() async {
    var hs = {'Authorization': 'Bearer DZYqV4MD{1#{UP!N'};
    try {
      var response = await Dio().get('http://localhost:8000/vault/load',
          options: Options(headers: hs));
      for (var c in response.data['credentials']) {
        credentials.add(Cred.fromJson(c));
      }
      notifyListeners();
    } catch (e) {}
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

  Future<void> _persist() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setStringList(
    //     'store', credentials.map((cred) => jsonEncode(cred.toJson())).toList());
    // notifyListeners();
  }

  void add(Cred cred) async {
    var hs = {'Authorization': 'Bearer DZYqV4MD{1#{UP!N'};
    try {
      var response = await Dio().post('http://localhost:8000/vault/create',
          data: {
            'key': secret,
            'credential': cred.toJson(),
          },
          options: Options(headers: hs));

      if (response.statusCode == 200) {
        credentials.add(cred);
        notifyListeners();
      } else {
        print('failed to save');
      }
    } catch (e) {
      print(e);
    }
  }

  void remove(Cred cred) async {
    var hs = {'Authorization': 'Bearer DZYqV4MD{1#{UP!N'};
    try {
      var id = cred.id!;
      var response = await Dio().delete(
          'http://localhost:8000/vault/delete/$id',
          options: Options(headers: hs));
      if (response.statusCode == 200) {
        credentials.remove(cred);
        notifyListeners();
      } else {
        print('failed to save');
      }
    } catch (e) {
      print(e);
    }
  }

  void update(Cred old, Cred cred) async {
    var hs = {'Authorization': 'Bearer DZYqV4MD{1#{UP!N'};
    try {
      var id = cred.id!;
      if (cred.decrypted == null) {
        var decryptedResponse =
            await Dio().post('http://localhost:8000/vault/decrypt_one/$id',
                data: {
                  'key': secret,
                },
                options: Options(headers: hs));
        assert(decryptedResponse.statusCode == 200);
        var decrypted = decryptedResponse.data['s'];
        cred = cred.copyWith(decrypted: decrypted);
      }
      var response = await Dio().put('http://localhost:8000/vault/replace',
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
        print('failed to save');
      }
    } catch (e) {
      print(e);
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
