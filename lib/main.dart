// import 'package:device_preview/device_preview.dart';
import 'package:easymart/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   await SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//   runApp(
//     DevicePreview(
//       enabled: true,
//       builder: (context) => const MyApp(),
//     ),
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// ignore_for_file: use_build_context_synchronously

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        builder: (context, dataSnapShot) {
          return const SplashScreen();
        },
        future: null,
      ),
      // home: FutureBuilder(
      //   future: RememberUserPrefs.readUserInfo(),
      //   builder: (context, dataSnapShot) {
      //     if (dataSnapShot.data == null) {
      //       return const LoginScreen();
      //       // return const SplashScreen();
      //     } else {
      //       return DashboardOfFragments();
      //     }
      //   },
      // ),
    );
  }
}
// **************************
