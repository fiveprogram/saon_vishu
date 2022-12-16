import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  ///signInMethod
  Future<void> signInTransition(BuildContext context) async {
    try {
      //authエラーハンドリング
      if (emailController.text.isEmpty || passController.text.isEmpty) {
        showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('未入力の項目があります'),
                actions: [
                  CupertinoButton(
                      child: const Text('戻る'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              );
            });
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.code));
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'user-disabled') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
