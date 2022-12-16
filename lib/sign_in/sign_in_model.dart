import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInModel extends ChangeNotifier {
  final emailController =
      TextEditingController(text: 'yuta.nanana.tennis@gmail.com');
  final passController = TextEditingController(text: '03Yuta16');

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  ///signInMethod
  Future<void> signInTransition(BuildContext context) async {
    startLoading();
    print(isLoading);
    notifyListeners();

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
    } finally {
      endLoading();
      print(isLoading);
    }
  }
}
