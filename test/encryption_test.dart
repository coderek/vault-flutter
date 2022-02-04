import 'package:firstweb/models/credential.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('encryption', () {
    // key must be 16, 24, 32 char in length
    test('normal case, ', () {
      var str = 'abc';
      var key = 'ddefgdefgdefgefg';
      var encrypted = encrypt(str, key);
      expect(decrypt(encrypted, key), equals(str));
    });

    test('must be Key length not 128/192/256 bits.', () {
      var str = 'abc';
      var key = '';
      expect(() => encrypt(str, key), throwsA(anything));
    });
  });
}
