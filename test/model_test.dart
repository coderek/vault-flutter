import 'dart:convert';

import 'package:firstweb/models/credential.dart';
import 'package:dio/dio.dart';
import 'package:firstweb/models/random_password.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encrypt and decrypt', () {
    var str = 'abc';
    var key = 'ddefgdefgdefgefg';
    var encrypted = encrypt(str, key);
    expect(decrypt(encrypted, key), equals(str));
  });
  test('random password', () async {
    var generator = RandomPasswordGenerator();
    var password = generator.randomPassword(uppercase: true, numbers: true, specialChar: true, passwordLength: 16);
    print(password);
    expect(generator.checkPassword(password: password), greaterThan(0.9));


    var hs = {'Authorization': 'Bearer DZYqV4MD{1#{UP!N'};
    try {
      var response = await Dio().get('http://localhost:8000/vault/load',
          options: Options(headers: hs));
      for (var c in response.data['credentials']) {
        var cd = Cred.fromJson(c);
        print(cd);
      }
    } catch (e) {
      print(e);
    }
  });
}



// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}
