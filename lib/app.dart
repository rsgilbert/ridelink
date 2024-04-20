import 'package:flutter/material.dart';
import 'package:ridelink/login.dart';

class RidelinkApp extends StatefulWidget {
  const RidelinkApp({ Key? key }) : super(key: key);

  @override 
  State<RidelinkApp> createState() => _RidelinkAppState();
}

class _RidelinkAppState extends State<RidelinkApp> {


  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ridelink",
      initialRoute: "/login",
      routes: {
        "/login": (BuildContext context) => const LoginPage()
      },
      theme: ThemeData(useMaterial3: true),
    );
  }
}