import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:freezed_annotation/freezed_annotation.dart';
import '../misc/logger.dart';

part 'credential.freezed.dart';
part 'credential.g.dart';

var envars = Platform.environment;
var isProd = envars['ENV'] == 'prod';

var uuid = const Uuid();
var base = isProd ? 'https://derekzeng.me' : 'http://localhost:8000';
var key = isProd ? "Da(r_gAjuu(p9k,rAKC%2*d\\5tTwt>pwp" : 'whatthefuck';

var hs = {
  'Authorization': isProd
      ? 'Token e615966b599918f43f661677f40e139880abb780'
      : 'Token 41f6bfb5fb56fd082731bf9b8de1a624e973e9de',
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

@freezed
class Cred with _$Cred {
  // required for custom method
  const Cred._();
  factory Cred({
    int? id,
    required String username,
    required String password,
    String? decrypted,
    required String description,
    required String website,
    required String category,
  }) = _Cred;
  factory Cred.fromJson(Map<String, dynamic> json) => _$CredFromJson(json);
  bool match(String term) {
    if (term.isEmpty) {
      return true;
    }
    var s = RegExp(term, caseSensitive: false);
    return s.hasMatch(username) ||
        s.hasMatch(description) ||
        s.hasMatch(website) ||
        s.hasMatch(category);
  }
}

class Vault = _Vault with _$Vault;

abstract class _Vault with Store {
  @observable
  ObservableList<Cred> _credentials = ObservableList();

  String secret = key;

  List<Cred> getCredentials(String search) {
    List<Cred> filteredList = [];
    for (Cred cred in _credentials) {
      if (cred.match(search)) {
        filteredList.add(cred);
      }
    }
    return filteredList;
  }

  @action
  init() async {
    var uri = Uri.parse('$base/vault/api/credentials');
    var response = await http.get(uri, headers: hs);
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      _credentials.clear();
      for (var c in decodedResponse) {
        _credentials.add(Cred.fromJson(c));
      }
    } else {
      logger.e('Failed to get credentials');
    }
  }

  @computed
  List<String> get categories {
    Set<String> ret = {};
    for (var c in _credentials) {
      ret.add(c.category);
    }
    return ret.toList();
  }

  @action
  add(Cred cred) async {
    var uri = Uri.parse('$base/vault/api/credentials');
    var response = await http.post(uri,
        body: jsonEncode({
          'key': secret,
          'credential': cred.toJson(),
        }),
        headers: hs);
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final id = decodedResponse['id'];
      _credentials.insert(0, cred.copyWith(id: id));
    } else {
      logger.w('Failed to decrypt password.');
    }
  }

  @action
  remove(Cred cred) async {
    var id = cred.id!;
    var uri = Uri.parse('$base/vault/api/credentials/$id');
    var response = await http.delete(uri, headers: hs);
    if (response.statusCode == 200) {
      _credentials.remove(cred);
    } else {
      logger.w('Failed to save');
    }
  }

  @action
  update(Cred old, Cred cred) async {
    var id = cred.id;
    var uri = Uri.parse('$base/vault/api/credentials/$id');
    var response = await http.put(uri,
        body: jsonEncode({
          'credential': cred.toJson(),
          'key': secret,
        }),
        headers: hs);
    if (response.statusCode == 200) {
      var i = _credentials.indexOf(old);
      _credentials.replaceRange(i, i + 1, [cred]);
    } else {
      logger.w('Failed to save');
    }
  }

  @action
  loadPasswordForCredAt(int index) async {
    var cred = _credentials[index];
    var uri = Uri.parse('$base/vault/api/credentials/${cred.id}?key=$secret');
    assert(cred.id != null, 'update cred with null id');
    if (cred.decrypted == null) {
      var decryptedResponse = await http.get(uri, headers: hs);
      assert(decryptedResponse.statusCode == 200, 'can\'t decrpyt');
      var data = jsonDecode(utf8.decode(decryptedResponse.bodyBytes));
      var decrypted = data['s'];
      cred = cred.copyWith(password: decrypted);
      _credentials.replaceRange(index, index + 1, [cred]);
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
