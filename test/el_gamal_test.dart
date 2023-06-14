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


    test('sings and fails to verify altered signatures', () {
      Uint8List message = Uint8List.fromList([]);
      Map<String, BigInt> signature = elGamal.sign(privateKey, message);
      expect(elGamal.verifySignature(publicKey, Uint8List.fromList([1]), signature), isFalse);
      expect(elGamal.verifySignature(publicKey + BigInt.one, message, signature), isFalse);
      expect(elGamal.verifySignature(publicKey, message,
          {"s": signature["s"]!, "r": signature["r"]! + BigInt.one}), isFalse);
    });
  });


  group('ElGamal encryption scheme tests', () {
    late BigInt privateKey, publicKey;
    final ElGamal elGamal = ElGamal();

    setUp(() {
      privateKey = elGamal.generateRand(512);
      publicKey = elGamal.getPublicKey(privateKey);
    });

    test('encrypts and decrypts data block', () {
      BigInt dataBlock = BigInt.from(42);
      Map<String, BigInt> cipherText = elGamal.encryptDataBlock(publicKey, dataBlock);
      expect(elGamal.decryptDataBlock(privateKey, cipherText), dataBlock);

      dataBlock = BigInt.from(1234567890);
      cipherText = elGamal.encryptDataBlock(publicKey, dataBlock);
      expect(elGamal.decryptDataBlock(privateKey, cipherText), dataBlock);

      dataBlock = BigInt.from(6846541231561547524);
      cipherText = elGamal.encryptDataBlock(publicKey, dataBlock);
      expect(elGamal.decryptDataBlock(privateKey, cipherText), dataBlock);
    });

    test('encrypts and decrypts messages', () {
      Uint8List message = Uint8List.fromList([1, 2, 3]);
      List<Map<String, BigInt>> cipherText = elGamal.encryptMessage(publicKey, message);
      expect(elGamal.decryptMessage(privateKey, cipherText).sublist(0, 3), message);
      expect(elGamal.decryptMessage(privateKey, cipherText).sublist(3), Uint8List.fromList(List.filled(508, 0)));

      message = Uint8List.fromList(List.filled(1022, 42));
      cipherText = elGamal.encryptMessage(publicKey, message);
      expect(elGamal.decryptMessage(privateKey, cipherText), message);
    });
  });
}
