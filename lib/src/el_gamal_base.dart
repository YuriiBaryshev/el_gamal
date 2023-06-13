import 'dart:math';
import 'dart:typed_data';
import 'package:hash_functions/hash_functions.dart';

/// Implements ElGamal encryption and signature schemes for 4096 bits
class ElGamal {
  BigInt p = BigInt.parse(
      "d885ba075554c41a28019e8dd871ae2a29dba8cd18420feeab379a75ad3593d19c0d22d4"
          "b6030571ed62666608fdd090e5ef8988c0e57172500516bd5d9636998e23ca49a211"
          "cac719b7fabafa9b60709f011b5f122b830ddd8664bb44738123216b1ce89ea095eb"
          "3b15cc7b2dc5278de773606740f600ecf0235d108c44c2c81944b4e2187046c246de"
          "1316a9b1c0f8246cca8c497431350b2bc9f57538bff197004f33c58a22cac52f8d9c"
          "4eb42dedae279ae0716372f346db51de944e00ad033288af69b9a23650dfee5d77e5"
          "153ffd5294900afb86e05dfe98ec75339a2f5b8c432a7f7f5719837c9c0ad5458455"
          "13580b3fb7bf4427c85c15c833cbf1ad2e7cadb22b4ac095c81d7f1549d233fcce30"
          "f173da654dbd3ba7bd5f31fbf8f413834da8a5841f7471c4a98aef4c6f92bb0ff6cc"
          "1f58a8f5254660b1865626d2c9e71f084372c4d737b7e772e72bf9fcb216c8b4e044"
          "07c6f7dc83568ce9fdcdeeaa9fd4c17c63c32e8ddf52620907973d71ca8de2a027bb"
          "58885a8888824b8db3c2eaf459ee89771d7a313772ce74dcbd3b53e69d66793dee87"
          "702e4d12a3c824f5e75643863d4af68e63d76a56f12201453312aae28b8a19cbe29f"
          "78d9990ac9e7ccee1ae1a031f956e75074846ed7d2af18d22fb17284496e224ea638"
          "6c038c596461f3c29c5265ec7c7453c9557fc334902fa3404430de63e04de8480339",
      radix: 16);

  BigInt g = BigInt.parse(
      "b9b92c90a36fe92dbe29a56212f34a2f81e74fbbac39473f256170939afdf3ee3a198b9f"
          "0f6752a3da08bd4d3421a78f9afe785f3ab96a94f306698e0ecd626b39f07253a6fd"
          "b1f05d030840dc3130f6dc479fe32ca836aa68c29f8639603160820c94fae430e97d"
          "f810b2c964298c07d126d356d9fb1a549c61c154bee50d32b293a765f355811d02bb"
          "5c1ba1aa71b255256370485446d39bb0793c558cdf7438c2fbd8c93f8c5cea797374"
          "8f2115e5a8044ed71206f051da0936b67712fb1569b63bf6a228f1d89094a526f191"
          "3795c5296a1981cca3b0c19d806023db02ebfba2e8e5f59be1d8ea5041e80917dffa"
          "23c1079e1e80435c7f7393f754f8e149822e3476895dc0cfada4c9c476598987ee90"
          "fc65eb3db07d1af2d146aeb6c0a0ec468f1ad6718270b2750a6814877c6bfd129231"
          "650f12e653a8d3e27b28d0ad49e1e72fd3dadf3dc218b8610e182b69f4623c42a64b"
          "462ae728c936e1c5755ec65cf8695e9ddad395a5e5c7663e8d699481a2d06a9474d3"
          "51c68e788234780b788a21fe0ed66a24c713e8bed40142fcf970e3576c63a9d36c8b"
          "b1efacba2b59ab17a6f0aae7b7b31a97ccf1b8d7f4507c068215c293acd15136379d"
          "8f46e080b1db618caa654c9e601eabebb8c838ae1054574fdae71362c16cbb6e9d0b"
          "59b160af4db6855892cc990eb30b42b8e0390a05e223519ee45ffbf738f5b94f900b",
      radix: 16);


  final SHA1 sha1 = SHA1();


  ///Sign with a privateKey
  ///JSON/mapping is outputted in format
  ///```
  ///{"r": ...,
  ///"s": ...
  ///}
  ///```
  Map<String, BigInt> sign(BigInt privateKey, Uint8List message) {
    BigInt k = (generateRand(512) % (p - BigInt.two)) + BigInt.two;
    BigInt r = g.modPow(k, p);

    Uint8List hashValue = sha1.process(message);
    BigInt s = (_uint8ListToBigInt(hashValue) - (privateKey * r)) % (p - BigInt.one);
    s = (s * k.modInverse(p - BigInt.one)) % (p - BigInt.one);

    if(s == BigInt.zero) {
      return sign(privateKey, message);
    }

    return {
      "r": r,
      "s": BigInt.zero
    };
  }


  ///Verifies signature in the following format
  ///```
  ///{"r": ...,
  ///"s": ...
  ///}
  ///```
  bool verifySignature(BigInt publicKey, Uint8List message, Map<String, BigInt> signature) {
    if (signature["s"] == null) {
      throw ArgumentError("Signature must have `s` field");
    }

    if (signature["r"] == null) {
      throw ArgumentError("Signature must have `r` field");
    }

    BigInt y = publicKey.modInverse(p);
    Uint8List hashValue = sha1.process(message);
    BigInt u1 = (
        _uint8ListToBigInt(hashValue) * signature["s"]!.modInverse(p - BigInt.one)
      ) % (p - BigInt.one);
    BigInt u2 = (
        signature["r"]! * signature["s"]!.modInverse(p - BigInt.one)
      ) % (p - BigInt.one);
    BigInt v = (g.modPow(u1, p) * y.modPow(u2, p)) % p;
    return v == signature["r"]!;
  }


  ///Computes public key for the private key
  BigInt getPublicKey(BigInt privateKey) {
    return g.modPow(privateKey, p);
  }


  ///Generates random number
  BigInt generateRand(int byteLength) {
    String hexPresentation = "";
    Random rand = Random.secure();
    for(int i = 0; i < byteLength; i++) {
      hexPresentation = hexPresentation + rand.nextInt(255).toRadixString(16).padLeft(2, "0");
    }
    BigInt randNumber = BigInt.parse(hexPresentation, radix: 16);
    return randNumber;
  }


  ///Converts Uint8List to BigInt
  BigInt _uint8ListToBigInt(Uint8List list) {
    BigInt output = BigInt.zero;
    for(int i = 0; i < list.length; i++) {
      output = output << 8;
      output = output + BigInt.from(list[i]);
    }
    return output;
  }
}
