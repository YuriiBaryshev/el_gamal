import 'package:el_gamal/el_gamal.dart';
import 'dart:typed_data';

void main() {
  ElGamal elGamal = ElGamal();
  BigInt privateKey = elGamal.generateRand(512);
  BigInt publicKey = elGamal.getPublicKey(privateKey);
  Uint8List message = Uint8List.fromList([1, 2, 3]);

  //...
  //Signing
  Map<String, BigInt> signature = elGamal.sign(privateKey, message);
  print(elGamal.verifySignature(publicKey, message, signature)); //true

  Uint8List forgedMessage = Uint8List.fromList([1, 2, 4]);
  print(elGamal.verifySignature(publicKey, forgedMessage, signature)); //false

  //Meanwhile in the parallel multiverse...
  //Encrypting
  List<Map<String, BigInt>> cipherText = elGamal.encryptMessage(publicKey, message);
  print(elGamal.decryptMessage(privateKey, cipherText)); //[1, 2, 3, 0, 0, ... 0] 511 elements in total
}
