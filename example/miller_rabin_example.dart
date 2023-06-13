import 'package:el_gamal/el_gamal.dart';
import 'dart:math';

void main() {
  MillerRabin millerRabin = MillerRabin(100);
  
  BigInt p = BigInt.zero;
  while(!millerRabin.isPrime(p)) {
    p = generateRand(512) + BigInt.parse(
        "1000000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000000000000000000000000000000000000000"
            "000000000000000000000000000000", radix: 16
    );
  }
  print(p.toRadixString(16));
}


BigInt generateRand(int byteLength) {
  String hexPresentation = "";
  Random rand = Random.secure();
  for(int i = 0; i < byteLength; i++) {
    hexPresentation = hexPresentation + rand.nextInt(255).toRadixString(16).padLeft(2, "0");
  }
  BigInt randNumber = BigInt.parse(hexPresentation, radix: 16);
  return randNumber;
}