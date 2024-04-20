import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView(
      children: [
        Column(
          children: [
            Image.asset("assets/ridelink.png"),
            Text(
              "LOGIN",
              style: Theme.of(context).textTheme.headlineLarge,
            )
          ],
        ),
        TextField( 
          controller: _emailController,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: "Password"),
          obscureText: true,
        ),

        OverflowBar(
          children: [
            TextButton(onPressed: onCancel, child: const Text("CANCEL"), style: TextButton.styleFrom(foregroundColor: Theme.of(context).secondaryHeaderColor)),
            ElevatedButton(onPressed: onLoginPressed, child: const Text("LOGIN"))
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
  }

  onLoginPressed() {
    print("Login pressed");
  }
}
