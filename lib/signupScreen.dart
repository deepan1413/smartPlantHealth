import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signup() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showToast('Please fill in all fields');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      showToast("Account created successfully. Please login to continue.");
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
    } catch (e) {
      String errorMessage = handleFirebaseAuthError(e);
      showToast(errorMessage);
    }
  }

  String handleFirebaseAuthError(dynamic error) {
    String errorMessage = 'An error occurred. Please try again.';

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use by another account.';
          break;
        case 'weak-password':
          errorMessage =
              'The password is too weak. Please choose a stronger password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = error.message ?? 'An unknown error occurred.';
      }
    }

    return errorMessage;
  }

  void showToast(String message) {
    DelightToastBar(
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3),
      builder: (context) {
        return ToastCard(title: Text(message));
      },
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'assets/45869-farmers.json',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                cursorColor: Colors.greenAccent,
                decoration: InputDecoration(
                    hintText: "EMAIL",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    focusedBorder: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: passwordController,
                cursorColor: Colors.greenAccent,
                decoration: InputDecoration(
                    hintText: "PASSWORD",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    focusedBorder: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent))),
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.greenAccent),
              child: Center(
                child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(LinearBorder.none)),
                  child: const Center(
                    child: Text(
                      'SIGNUP',
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'odibeeSans',
                      ),
                    ),
                  ),
                  onPressed: signup,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
