import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tastybite/authentication/auth_page.dart';
import 'package:tastybite/global/global.dart';
import 'package:tastybite/pages/home_page.dart';
import 'package:tastybite/widgets/custom_text_field.dart';
import 'package:tastybite/widgets/error_dialog.dart';
import 'package:tastybite/widgets/loading_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

// Login Form Validation
  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Login
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: "Please write email & password");
          });
    }
  }

  loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return const LoadingDialog(message: "checking details");
      },
    );
    User? currentUser;

    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user!;
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
      readDataAndSetDataLocally(currentUser!);
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!
            .setString("email", snapshot.data()!["userEmail"]);
        await sharedPreferences!
            .setString("name", snapshot.data()!["userName"]);
        await sharedPreferences!
            .setString("photoUrl", snapshot.data()!["userProfileUrl"]);

        List<String> userCartList = snapshot.data()!["userCart"].cast<String>();

        await sharedPreferences!.setStringList("userCart", userCartList);

        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => HomePage()));
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => AuthPage()));

        showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: "no record found...");
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 20),
          Container(
            child: Image.asset(
              'assets/images/depositphotos_668296520-stock-illustration-burger-soda-cartoon-vector-icon.jpg',
              height: 230,
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
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
                  const SizedBox(height: 10),

                  // button
                  ElevatedButton(
                    onPressed: () {
                      print("loging....");
                      formValidation();
                    },
                    child: Text(
                      "Login",
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
                ],
              ))
        ],
      ),
    );
  }
}
