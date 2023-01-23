import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salon_vishu/main_select_page.dart';

import '../domain/version.dart';

class SignUpModel extends ChangeNotifier {
  final emailController =
      TextEditingController(text: 'yuta.nanana.tennis@gmail.com');
  final passController = TextEditingController(text: '03Yuta16');
  final nameController = TextEditingController(text: '五影 裕太');
  final dateOfBirthController = TextEditingController();
  final telephoneNumberController = TextEditingController(text: '09019645524');

  String? gender;

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
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1920, 3, 5),
        maxTime: DateTime.now(), onChanged: (date) {
      null;
    }, onConfirm: (date) {
      dateOfBirthController.text = '${date.year}年${date.month}月${date.day}日';
      registerDateOfBirth = date;
      notifyListeners();
    },
        currentTime: dateOfBirthController.text.isEmpty
            ? DateTime.now()
            : registerDateOfBirth,
        locale: LocaleType.jp);
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
        'email': emailController.text,
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
          MaterialPageRoute(builder: (context) => const MainSelectPage()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      ///snackBarを定義
      SnackBar snackBar = SnackBar(
        content: Text(
          e.code,
          style: const TextStyle(color: Colors.black54),
        ),
        backgroundColor: HexColor('#8d9895'),
      );

      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        notifyListeners();
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        notifyListeners();
      } else if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        notifyListeners();
      } else if (e.code == 'user-disabled') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
