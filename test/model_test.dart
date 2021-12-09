import 'package:firstweb/models/credential.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encrypt and decrypt', () {
    var str = 'abc';
    var key = 'ddefgdefgdefgefg';
    var encrypted = encrypt(str, key);
    expect(decrypt(encrypted, key), equals(str));
  });
}
