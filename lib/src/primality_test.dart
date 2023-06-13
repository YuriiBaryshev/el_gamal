import 'dart:math';

class MillerRabin {
  late int _roundsNumber;


  ///Creates instance of Miller-Rabin test with `k` number of testing rounds
  MillerRabin(int k) {
    if(k < 1) {
      throw ArgumentError("Miller-Rabin: number of rounds must be larger 0");
    }
    _roundsNumber = k;
  }


  ///Checks whenever `n` is prime number by running test `k` times
  bool isPrime(BigInt n) {
    if(n.isEven) {
      return false;
    }

    bool output = true;

    for (int i = 0; i < _roundsNumber; i++) {
      BigInt a = _generateRand(n);

    }

    return output;
  }


  ///Generates long random number 1 < a < n-1 of `maxBitLength`
  ///`maxBitLength` must be 0 modulo 8 for proper performance
  BigInt _generateRand(BigInt n) {
    String hexPresentation = "";
    Random rand = Random.secure();
    for(int i = 0; i < (n.bitLength >> 3); i++) {
      hexPresentation = hexPresentation + rand.nextInt(255).toRadixString(16).padLeft(2, "0");
    }
    BigInt randNumber = BigInt.parse(hexPresentation, radix: 16);
    return (randNumber % n);
  }
}