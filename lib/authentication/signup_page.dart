import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tastybite/global/global.dart';
import 'package:tastybite/pages/home_page.dart';
import 'package:tastybite/widgets/custom_text_field.dart';
import 'package:tastybite/widgets/error_dialog.dart';
import 'package:tastybite/widgets/loading_dialog.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String sellerImageUrl = "";

// image
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  // Validation
  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(message: "Please select an image..");
        },
      );
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty) {
          // start uploading image
          showDialog(
            context: context,
            builder: (c) {
              return LoadingDialog(message: "Registering account");
            },
          );

          String fileName = DateTime.now().millisecondsSinceEpoch.toString();

          fStorage.Reference reference = fStorage.FirebaseStorage.instance
              .ref()
              .child("users")
              .child(fileName);
          fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});

          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;

            // Save info into firebase
            authenticateSeller();
          });
        } else {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                  message:
                      "Please write the complete required info for registeration..");
            },
          );
        }
      } else {
        // show error message
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: "password do not match..");
          },
        );
      }
    }
  }

  // Authenticate
  void authenticateSeller() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      // show error message
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(message: error.message.toString());
        },
      );
    });
    if (currentUser != null) {
      await saveDataToFireStore(currentUser!);
      Navigator.pop(context); // Remove the pop here
      // Send user to homepage
      Route newRoute = MaterialPageRoute(builder: (context) => HomePage());
      Navigator.pushReplacement(context, newRoute);
    }
  }

  // Save data to firebase firestore
  Future saveDataToFireStore(User currentUser) async {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "userUID": currentUser.uid,
      "userEmail": currentUser.email,
      "userName": nameController.text.trim(),
      "userProfileUrl": sellerImageUrl,
      "status": "approved",
      "userCart": ['garbageValue'],
    });

    // Save data localy
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
    await sharedPreferences!.setStringList("userCart", ['garbageValue']);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            Stack(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.20,
                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null
                      ? null
                      : FileImage(
                          File(
                            imageXFile!.path,
                          ),
                        ),
                  child: imageXFile == null
                      ? Icon(
                          Icons.person,
                          size: MediaQuery.of(context).size.width * 0.20,
                          color: Colors.grey,
                        )
                      : null,
                ),
                Positioned(
                  bottom: -5,
                  left: 80,
                  child: IconButton(
                    onPressed: () => _getImage(),
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      data: Icons.person,
                      controller: nameController,
                      hintText: "Name",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.email,
                      controller: emailController,
                      hintText: "Email",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.lock,
                      controller: passwordController,
                      hintText: "Password",
                      isObsecre: true,
                    ),
                    CustomTextField(
                      data: Icons.lock,
                      controller: confirmPasswordController,
                      hintText: "Confirm Passwod",
                      isObsecre: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        formValidation();
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          )),
                    ),
                    const SizedBox(height: 20),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
