import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridelink/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void onSignoutTapped() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
  }

  uploadProfilePicture() async {
    File picture = await ImagePicke
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(child: Text("Sign out"), onTap: onSignoutTapped)
            ];
          })
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [Text("Profile page")],
        ),
      ),
    );
  }
}
