import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  final birthDayController = TextEditingController();
  final telephoneNumberController = TextEditingController();

  Future<void> registerUserInformation(User? uid) async {
    await FirebaseFirestore.instance.collection('users').add({
      'uid': uid,
      'email': emailController.text,
      'name': nameController.text,
      'birthDay': birthDayController.text,
    });
  }

  ///signUpMethod
  Future<void> signUpTransition(BuildContext context) async {
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
