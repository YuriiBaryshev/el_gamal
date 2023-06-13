import 'package:big_numbers_arithmetic/big_numbers_arithmetic.dart';

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
    bool output = true;
    for (int i = 0; i < _roundsNumber; i++) {
      //TODO: implementation
    }
    return output;
  }
}