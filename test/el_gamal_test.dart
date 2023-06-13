import 'dart:typed_data';

import 'package:el_gamal/el_gamal.dart';
import 'package:test/test.dart';

void main() {
  group('ElGamal signature scheme tests', () {
    late BigInt privateKey, publicKey;
    final ElGamal elGamal = ElGamal();

    setUp(() {
      privateKey = elGamal.generateRand(512);
      publicKey = elGamal.getPublicKey(privateKey);
    });

    test('sings and verifies signature', () {
      Uint8List message = Uint8List.fromList([]);
      Map<String, BigInt> signature = elGamal.sign(privateKey, message);
      expect(elGamal.verifySignature(publicKey, message, signature), isTrue);

      message = Uint8List.fromList([1, 2, 3]);
      signature = elGamal.sign(privateKey, message);
      expect(elGamal.verifySignature(publicKey, message, signature), isTrue);


      message = Uint8List.fromList(List.filled(42, 42));
      signature = elGamal.sign(privateKey, message);
      expect(elGamal.verifySignature(publicKey, message, signature), isTrue);
    });
  });
}
