import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'Assests/lottie/shop.json',
      // width: 500,
      // height: 500,
      // width: MediaQuery.of(context).size.width * 0.80,
      // height: MediaQuery.of(context).size.height * 0.80,
    );
  }
}

// class SecondLoading extends StatelessWidget {
//   const SecondLoading({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Lottie.asset(
//       'assets/lottie/man.json',
//       // width: 700,
//       // height: 400,
//       // width: MediaQuery.of(context).size.width*0.95 ,
//       // height: MediaQuery.of(context).size.height*0.45,
//     );
//   }
// }
