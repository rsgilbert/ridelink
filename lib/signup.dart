import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ridelink/snackbar_global.dart';
import 'package:ridelink/utils.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: [
        const SizedBox(height: 40),
        Column(
          children: [
            Image.asset("assets/ridelink.png", height: 60),
            SizedBox(height: 20),
            Text("SIGNUP",
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold))
          ],
        ),
        const SizedBox(height: 40),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
              hintText: "email"),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
              labelText: "Password", border: OutlineInputBorder()),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        OverflowBar(
          alignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor),
                child: const Text("CANCEL")),
            ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary),
                    
                onPressed: onSignupPressed,
                child: const Text("SIGNUP"))
          ],
        )
      ],
    )));
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  onCancel() {
    _emailController.clear();
    _passwordController.clear();
    navigateToLoginPage();
  }

  navigateToLoginPage() {
    Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
  }

  onSignupPressed() async {
    try {
      print("onSignupPressed");
      print(_emailController.text);
      print(_passwordController.text);
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      print(credential);
      SnackbarGlobal.show("Account created successfully. Please login");
      navigateToLoginPage();
    } on FirebaseAuthException catch (e) {
      print(e);
      SnackbarGlobal.show("Failed to signup: ${e.message}");
    }
  }
}
