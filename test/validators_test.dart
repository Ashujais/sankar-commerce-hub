import 'package:flutter_test/flutter_test.dart';
import 'package:sankar_app/core/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateEmail checks standard email patterns', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('invalid-email'), isNotNull);
      expect(Validators.validateEmail('user@domain'), isNotNull);
      expect(Validators.validateEmail('intern@sankargroup.com'), isNull);
    });

    test('validatePassword enforces minimum 6 character length', () {
      expect(Validators.validatePassword(''), isNotNull);
      expect(Validators.validatePassword('12345'), isNotNull);
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('Password123!'), isNull);
    });

    test('validateName enforces length', () {
      expect(Validators.validateName(''), isNotNull);
      expect(Validators.validateName('Al'), isNotNull);
      expect(Validators.validateName('Rohan Sharma'), isNull);
    });

    test('validateConfirmPassword checks match', () {
      expect(Validators.validateConfirmPassword('pass1', 'pass2'), isNotNull);
      expect(Validators.validateConfirmPassword('pass123', 'pass123'), isNull);
    });
  });
}
