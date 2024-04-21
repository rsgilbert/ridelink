import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridelink/loading_overlay.dart';
import 'package:ridelink/snackbar_global.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;

  User user() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      SnackbarGlobal.show("No user found");
    }
    return user!;
  }

  void onSignoutTapped() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
  }

  void onUploadProfilePicturePressed() async {
    try {
      showLoadingOverlay();
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref();
      XFile? image = await pickImage();
      if (image == null) {
        SnackbarGlobal.show("No image picked");
        return;
      }

      String filename = image.name;
      final fileRef = storageRef.child(filename);
      File file = File(image.path);
      await fileRef.putFile(file);
      String photoURL = await fileRef.getDownloadURL();
      await updateUserPhotoUrl(photoURL);
      setState(() {});
      SnackbarGlobal.show("Profile picture uploaded successfully");
    } on FirebaseException catch (e) {
      print(e);
      SnackbarGlobal.show("Failed to upload: ${e.message}");
    } finally {
      hideLoadingOverlay();
    }
  }

  void onRemoveProfilePicturePressed() async {
    try {
      showLoadingOverlay();
      await user().updatePhotoURL(null);
      setState(() {});
      SnackbarGlobal.show("Profile picture removed successfully");
    } on FirebaseException catch (e) {
      print(e);
      SnackbarGlobal.show("Failed to remove profile picture: ${e.message}");
    } finally {
      hideLoadingOverlay();
    }
  }

  String userPhotoURL() {
    return user().photoURL ?? "";
  }

  String userEmail() {
    return user().email ?? "";
  }

  hideLoadingOverlay() {
    LoadingOverlay.of(context).hide();
  }

  showLoadingOverlay() {
    LoadingOverlay.of(context).show();
  }

  updateUserPhotoUrl(String photoURL) async {
    await user().updatePhotoURL(photoURL);
  }

  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  void initializeTextControls() {
    _emailController.text = user().email ?? "";
    _phoneNumberController.text = user().phoneNumber ?? "";
    _displayNameController.text = user().displayName ?? "";
  }

  @override
  void initState() {
    super.initState();
    initializeTextControls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                    onTap: onUploadProfilePicturePressed,
                    child: const Text("Upload Profile Picture")),
                PopupMenuItem(
                    onTap: onRemoveProfilePicturePressed,
                    child: const Text("Remove Profile Picture")),
                PopupMenuItem(
                  onTap: onSignoutTapped,
                  child: const Text("Sign out"),
                )
              ];
            })
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              profileImage(),
              const SizedBox(height: 24),
              // Text(user().photoURL ?? ""),
              TextField(
                controller: _emailController,
                enabled: false,
                decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    hintText: "Email"),
              ),
              const SizedBox(height: 16),
              TextField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                      labelText: "Display Name",
                      border: OutlineInputBorder(),
                      hintText: "name")),
              const SizedBox(height: 16),
              OverflowBar(
                alignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary),
                      onPressed: onSavePressed,
                      child: const Text("SAVE"))
                ],
              )
            ],
          ),
        ));
  }

  onSavePressed() async {
    try {
      // if (_isLoading) {
      print("Showing overlay");
      showLoadingOverlay();
      // }
      user().updateDisplayName(_displayNameController.text);
      SnackbarGlobal.show("Profile saved successfully");
    } on FirebaseException catch (e) {
      SnackbarGlobal.show("Failed to save: ${e.message}");
    } finally {
      hideLoadingOverlay();
    }
  }

  Widget profileImage() {
    String photoURL = userPhotoURL();
    if (photoURL == "") {
      return Image.asset("assets/default_profile_picture.png",
          fit: BoxFit.contain, height: 200);
    } else {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(photoURL), fit: BoxFit.cover),
            border: Border.all(color: Colors.red, width: 2)),
      );
    }
  }

  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
}
