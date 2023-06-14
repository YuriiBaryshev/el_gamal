This is pure Dart lib which implements ElGamal signature and encryption shemes

## Features

1. Sign messages (Uint8List)
2. Verify messages
3. Encrypt messages
4. Decrypt messages
5. Encrypt data blocks
6. Decrypt data blocks
7. Check big numbers primality using Miller-Rabin test

## Getting started

1. Install Dart SDK and Flutter framework.
2. Install IDE (this was developed using Android studio, but any Dart-supporting will do).
3. Run command flutter test in project's folder in order to see that every thing is alright (all tests passed).

## Usage

Primality testing
```dart
      MillerRabin millerRabin = MillerRabin(100); //number of rounds the more - the better
      BigInt someNumber =  BigInt.parse("1234567890abcdef", radix: 16);
      bool answer = millerRabin.isPrime(someNumber);
      print(answer);
```

ElGamal key generation
```dart
    ElGamal elGamal = ElGamal();
    BigInt privateKey = elGamal.generateRand(512);
    BigInt publicKey = elGamal.getPublicKey(privateKey);
```

ElGamal signing (assuming keys have been generated)
```dart
    Uint8List message = Uint8List.fromList([1, 2, 3]);
    Map<String, BigInt> signature = elGamal.sign(privateKey, message);
    //sending to the other side
    bool isValid = elGamal.verifySignature(publicKey, message, signature); //true
```

ElGamal encryption (assuming keys have been generated)
```dart
    Uint8List message = Uint8List.fromList(List.filled(1022, 42));
    List<Map<String, BigInt>>cipherText = elGamal.encryptMessage(publicKey, message);
    //sending to the other side
    Uint8List decryptedMessage = elGamal.decryptMessage(privateKey, cipherText); // [42, 42, ..., 42] 1022 elements in total
```

One may refer to [example](./example) folder for more examples
