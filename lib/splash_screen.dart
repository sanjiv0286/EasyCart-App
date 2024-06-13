// import 'package:easymart/customloading.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// import 'Users/authentication/login.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 6), () {
//       // Navigator.of(context).pushReplacement(
//       // MaterialPageRoute(builder: (_) => OnboardingScreen()));
//       // *navigation using getx
//       // Get.off(() => const MyHomePage());
//       Get.off(() => const LoginScreen());
//       // Navigator.of(context).pushReplacement(MaterialPageRoute(
//       //     builder: (_) =>
//       //         Pref.showOnboarding ? OnboardingScreen() : const HomeScreen()));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // mq = MediaQuery.sizeOf(context);
//     // final screenSize = MediaQuery.of(context).size;
//     // double loadingSize =
//     //     screenSize.width * 0.3; // Adjust the loading size as needed
//     // double loading = screenSize.height * 0.3;
//     return SafeArea(
//       child: Scaffold(
//         // backgroundColor: Colors.transparent,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             // const Spacer(),
//             const CustomLoading(),
//             const Spacer(
//               flex: 1,
//             ),
//             Container(
//               alignment: Alignment.bottomCenter,
//               color: Colors.transparent, // Make the container transparent
//               child: const Text(
//                 "Shop Now",
//                 style: TextStyle(
//                   // color: Colors.white,
//                   fontSize: 50,
//                   fontStyle: FontStyle.italic,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
// }
// ***************************************************************************
import 'package:easymart/Users/UserPreferences/user_preferences.dart';
import 'package:easymart/Users/fragments/dashboard.dart';
import 'package:easymart/customloading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Users/authentication/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: RememberUserPrefs.readUserInfo(),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomLoading(),
                  const Spacer(flex: 1),
                  Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.transparent,
                    child: const Text(
                      "Shop Now",
                      style: TextStyle(
                        fontSize: 50,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              );
            } else if (dataSnapShot.hasError) {
              // Handle error case
              return Center(child: Text('Error: ${dataSnapShot.error}'));
            } else if (dataSnapShot.data == null) {
              // No user info, navigate to LoginScreen after delay
              Future.delayed(const Duration(seconds: 6), () {
                Get.off(() => const LoginScreen());
              });
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomLoading(),
                  const Spacer(flex: 1),
                  Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.transparent,
                    child: const Text(
                      "Shop Now",
                      style: TextStyle(
                        fontSize: 50,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              );
            } else {
              // User info available, navigate to DashboardOfFragments after delay
              Future.delayed(const Duration(seconds: 3), () {
                Get.off(() => DashboardOfFragments());
              });
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomLoading(),
                  const Spacer(flex: 1),
                  Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.transparent,
                    child: const Text(
                      "Shop Now",
                      style: TextStyle(
                        fontSize: 50,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
