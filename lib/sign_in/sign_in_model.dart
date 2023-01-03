import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salon_vishu/manager/firebase_option/firebase_options.dart';

class SignInModel extends ChangeNotifier {
  final emailController =
      TextEditingController(text: 'yuta.nanana.tennis@gmail.com');
  final passController = TextEditingController(text: '03Yuta16');

  DateTime createAccountDate = DateTime.now();

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  ///メールアドレスを使ってのサインイン
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

  ///Google Sign in
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> signInWithGoogle(BuildContext context) async {
    startLoading();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = result.user;

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
        {
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'dateOfBirth': '',
          'telephoneNumber': user.phoneNumber ?? '00000000000',
          'imgUrl': user.photoURL != '' ? user.photoURL : '',
          'dateTime': createAccountDate
        },
      );
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('ログインに失敗'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      endLoading();
    }
  }
}
