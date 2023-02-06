import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/profile.dart';
import '../firebase_options.dart';

class SignInModel extends ChangeNotifier {
  final emailController =
      TextEditingController(text: 'hiroshi.tennis@outlookl.com');
  final passController = TextEditingController(text: '03Yuta16');

  DateTime createAccountDate = DateTime.now();

  bool isLoading = false;

  final focusNode = FocusNode();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  List<Profile> profileList = [];

  Future<void> fetchProfile() async {
    final profileStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    profileStream.listen((snapshot) {
      profileList = snapshot.docs.map((DocumentSnapshot doc) {
        return Profile.fromFirestore(doc);
      }).toList();
      notifyListeners();
    });
  }

  ///メールアドレスを使ってのサインイン
  Future<void> signInTransition(BuildContext context) async {
    startLoading();
    print(isLoading);
    notifyListeners();

    try {
      //authエラーハンドリング
      if (emailController.text.isEmpty || passController.text.isEmpty) {
        await showDialog(
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
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('ユーザーが見つかりません。')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('パスワードに誤りがあります。')));
      } else if (e.code == 'user-disabled') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('指定のアカウントは使用できません。')));
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

      if (result.additionalUserInfo!.isNewUser) {
        final user = result.user;

        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
          {
            'uid': user.uid,
            'email': user.email,
            'name': user.displayName,
            'dateOfBirth': '',
            'telephoneNumber': user.phoneNumber ?? '00000000000',
            'imgUrl': user.photoURL != '' ? user.photoURL : '',
            'dateTime': createAccountDate,
            'gender': '',
          },
        );
      }
    } catch (e) {
      return;
    } finally {
      endLoading();
    }
  }

  Future<void> signInWithApple() async {
    startLoading();
    try {
      final auth = FirebaseAuth.instance;
      final appleProvider = AppleAuthProvider();
      if (kIsWeb) {
        print(auth.signInWithPopup(appleProvider).runtimeType);
        await auth.signInWithPopup(appleProvider);
      } else {
        final result = await auth.signInWithProvider(appleProvider);

        if (result.additionalUserInfo!.isNewUser) {
          final user = result.user;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .set(
            {
              'uid': user.uid,
              'email': user.email,
              'name': 'unknown',
              'dateOfBirth': '',
              'telephoneNumber': user.phoneNumber ?? '00000000000',
              'imgUrl': user.photoURL ?? '',
              'dateTime': createAccountDate,
              'gender': '',
            },
          );
        }
      }
    } catch (e) {
      return;
    } finally {
      endLoading();
    }
  }
}
