import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_vishu/main_select_page.dart';

import '../domain/version.dart';

class SignUpModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final telephoneNumberController = TextEditingController();

  String? gender;

  final focusNode = FocusNode();

  bool isLoading = false;
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  DateTime? registerDateOfBirth;
  DateTime createAccountDate = DateTime.now();

  ///cupertinoPicker 生年月日
  Future<void> dateOfBirthPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1980, 1, 1),
        lastDate: DateTime.now(),
        initialDate: dateOfBirthController.text == ''
            ? DateTime(1980, 1, 1)
            : registerDateOfBirth!,
        currentDate: DateTime.now());

    if (picked == null || registerDateOfBirth == picked) {
      return;
    }

    registerDateOfBirth = picked;
    dateOfBirthController.text =
        '${picked.year}年${picked.month}月${picked.day}日';
    notifyListeners();
  }

  ///signUpMethod
  Future<void> signUpTransition(BuildContext context) async {
    startLoading();

    try {
      if (emailController.text.isEmpty ||
          passController.text.isEmpty ||
          nameController.text.isEmpty ||
          dateOfBirthController.text.isEmpty ||
          telephoneNumberController.text.isEmpty ||
          gender == null) {
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

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'name': nameController.text,
        'dateOfBirth': dateOfBirthController.text,
        'telephoneNumber': telephoneNumberController.text,
        'imgUrl': '',
        'gender': gender,
        'dateTime': createAccountDate,
      });
      notifyListeners();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainSelectPage()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('パスワードが短すぎます。')));
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('そのメールアドレスは既に使用されています。')));
        notifyListeners();
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('無効なメールアドレスです。')));
        notifyListeners();
      } else if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('リクエストが重複しています。')));
        notifyListeners();
      } else if (e.code == 'user-disabled') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('こちらのアカウントはご使用できません。')));
        notifyListeners();
      }
    } finally {
      endLoading();
      notifyListeners();
    }
  }

  Version? version;
  Future<void> fetchVersion() async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> versionStream =
        FirebaseFirestore.instance
            .collection('force_update')
            .doc('uHoECUdMBarAX1H61FTC')
            .snapshots();

    versionStream.listen((snapshot) {
      version = Version.fromFirestore(snapshot);
      notifyListeners();
    });
  }
}
