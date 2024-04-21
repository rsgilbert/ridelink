import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ridelink/snackbar_global.dart';
import 'package:ridelink/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.green[100],
            child: SafeArea(
                child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 40),
                Column(
                  children: [
                    Image.asset("assets/ridelink.png", height: 60),
                    const SizedBox(height: 20),
                    Text("LOGIN",
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
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary),
                        onPressed: onLoginPressed,
                        child: const Text("LOGIN"))
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: onGoToSignupPressed,
                  child: Text("Not a user? Signup here",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                )
              ],
            ))));
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  onCancel() {
    _emailController.clear();
    _passwordController.clear();
  }

  navigateToProfilePage() {
    Navigator.of(context).pushNamedAndRemoveUntil("/profile", (route) => false);
  }

  onGoToSignupPressed() {
    Navigator.of(context).pushNamed("/signup");
  }

  onLoginPressed() async {
    try {
      print("onLoginPressed");
      print(_emailController.text);
      print(_passwordController.text);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      print(credential);
      navigateToProfilePage();
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == "user-not-found") {
        print("No user found for that email");
      } else if (e.code == "wrong-password") {
        print("Wrong password provided for that user");
      }
      SnackbarGlobal.show("Failed to login: ${e.message}");
    }
  }
}
