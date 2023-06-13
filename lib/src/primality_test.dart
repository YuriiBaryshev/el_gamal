import 'package:big_numbers_arithmetic/big_numbers_arithmetic.dart';
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
  bool isPrime(BigNumberX86 n) {
    BigNumberX86 one = BigNumberX86(n.maxBitLength);
    one.setHex("1");

    BigNumberX86 zero = BigNumberX86(n.maxBitLength);
    zero.setHex("0");

    //is even?
    if((n & one) == zero) {
      return false;
    }

    bool output = true;

    for (int i = 0; i < _roundsNumber; i++) {
      //TODO: implementation
    }
    return output;
  }


  ///Generates long random number 1 < a < n-1 of `maxBitLength`
  ///`maxBitLength` must be 0 modulo 8 for proper performance
  BigNumberX86 _generateRand(BigNumberX86 n) {
    String hexPresentation = "";
    Random rand = Random.secure();
    for(int i = 0; i < (n.maxBitLength >> 3); i++) {
      hexPresentation = hexPresentation + rand.nextInt(255).toRadixString(16).padLeft(2, "0");
    }
    BigNumberX86 randNumber = BigNumberX86(n.maxBitLength);
    randNumber.setHex(hexPresentation);
    return (randNumber % n);
  }
}