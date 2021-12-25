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
var base = isProd? 'https://derekzeng.me': 'http://localhost:8000';

var hs = {
  'Authorization': isProd
      ? 'Token e615966b599918f43f661677f40e139880abb780'
      : 'Token 41f6bfb5fb56fd082731bf9b8de1a624e973e9de',
  'Content-type' : 'application/json', 
  'Accept': 'application/json',
};

@freezed
class Cred with _$Cred {
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
}

class Vault = _Vault with _$Vault;

abstract class _Vault with Store {
  @observable
  ObservableList<Cred> credentials = ObservableList();

  String secret;

  _Vault({required this.secret});

  @action
  init() async {
    var uri = Uri.parse('$base/vault/api/credentials');
    var response = await http.get(uri, headers: hs);
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      credentials.clear();
      for (var c in decodedResponse) {
        credentials.add(Cred.fromJson(c));
      }
    } else {
      logger.e('Failed to get credentials');
    }
  }

  @computed
  List<String> get categories {
    Set<String> ret = {};
    for (var c in credentials) {
      ret.add(c.category);
    }
    return ret.toList();
  }

  @action
  add(Cred cred) async {
    var uri = Uri.parse('$base/vault/api/credentials');
    var response = await http.post(uri,
        body: {
          'key': secret,
          'credential': cred.toJson(),
        },
        headers: hs);
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final id = decodedResponse['id'];
      credentials.insert(0, cred.copyWith(id: id));
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
      credentials.remove(cred);
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
      var i = credentials.indexOf(old);
      credentials.replaceRange(i, i + 1, [cred]);
    } else {
      logger.w('Failed to save');
    }
  }
  @action
  loadPasswordForCredAt(int index) async {
    var cred = credentials[index];
    var uri = Uri.parse('$base/vault/api/credentials/${cred.id}?key=$secret');
    assert(cred.id != null, 'update cred with null id');
    if (cred.decrypted == null) {
      var decryptedResponse = await http.get(uri, headers: hs);
      assert(decryptedResponse.statusCode == 200, 'can\'t decrpyt');
      var data = jsonDecode(utf8.decode(decryptedResponse.bodyBytes));
      var decrypted = data['s'];
      cred = cred.copyWith(password: decrypted);
      credentials.replaceRange(index, index + 1, [cred]);
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
