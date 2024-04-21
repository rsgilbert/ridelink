import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridelink/loading_overlay.dart';
import 'package:ridelink/login.dart';
import 'package:ridelink/profile.dart';
import 'package:ridelink/signup.dart';
import 'package:ridelink/snackbar_global.dart';

class RidelinkApp extends StatefulWidget {
  const RidelinkApp({Key? key}) : super(key: key);

  @override
  State<RidelinkApp> createState() => _RidelinkAppState();
}

class _RidelinkAppState extends State<RidelinkApp> {
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  String initialRoute() {
    return isLoggedIn() ? "/profile" : "/login";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Ridelink",
        initialRoute: initialRoute(),
        routes: {
          "/login": (BuildContext context) =>
              const LoadingOverlay(child: LoginPage()),
          "/signup": (BuildContext context) =>
              const LoadingOverlay(child: SignupPage()),
          "/profile": (BuildContext context) =>
              const LoadingOverlay(child: ProfilePage())
        },
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(1, 27, 153, 139)),
        ),
        scaffoldMessengerKey: SnackbarGlobal.key);
  }
}
