import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as enc;

var uuid = const Uuid();

class Credential {
  late String id;
  String username;
  String? description;
  String? url;
  String? category;
  String? password;
  String? hashedPassword;

  Credential({required this.username, required this.password, this.description, this.category,
      this.url, this.hashedPassword}) {
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
  final List<Credential> credentials = [];
  final String secret;

  Vault({required this.secret}) {
    init();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonString = prefs.getStringList('store');
    if (jsonString != null) {
      for (String s in jsonString) {
        var cred = Credential.fromJson(jsonDecode(s));
        cred.password = decrypt(cred.hashedPassword!, secret);
        credentials.add(cred);
      }
      notifyListeners();
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

  Future<void> _persist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'store', credentials.map((cred) => jsonEncode(cred.toJson())).toList());
    notifyListeners();
  }

  void add(Credential cred) {
    cred.hashedPassword = encrypt(cred.password!, secret);
    credentials.add(cred);
    _persist();
  }

  void remove(Credential cred) {
    credentials.remove(cred);
    _persist();
  }

  void update(Credential cred) {
    _persist();
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
