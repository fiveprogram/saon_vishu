import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  ///signInMethod
  Future<void> signInTransition(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.code));
      if (e.code == 'auth/invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'auth/user-disabled') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'auth/user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'auth/wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'auth/too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
