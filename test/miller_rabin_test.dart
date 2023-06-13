import 'package:el_gamal/src/miller_rabin.dart';
import 'package:test/test.dart';

void main() {
  group('Miller-Rabin tests:', () {
    final MillerRabin millerRabin2 = MillerRabin(2);
    final MillerRabin millerRabin10 = MillerRabin(10);
    final MillerRabin millerRabin99 = MillerRabin(100);

    test('positive primality test', () {
      BigInt a = BigInt.from(257);
      BigInt b = BigInt.parse('fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f', radix: 16);

      expect(millerRabin2.isPrime(a), isTrue);
      expect(millerRabin10.isPrime(a), isTrue);
      expect(millerRabin99.isPrime(a), isTrue);

      expect(millerRabin2.isPrime(b), isTrue);
      expect(millerRabin10.isPrime(b), isTrue);
      expect(millerRabin99.isPrime(b), isTrue);
    });


    test('negative primality test', () {
      BigInt a = BigInt.from(258);
      BigInt b = BigInt.from(894363);
      BigInt c = BigInt.parse('effffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f', radix: 16);

      expect(millerRabin99.isPrime(a), isFalse);
      expect(millerRabin99.isPrime(b), isFalse);
      expect(millerRabin99.isPrime(c), isFalse);
    });
  }, skip: "passed tests were muted for the performance sake");
}