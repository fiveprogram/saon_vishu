import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

import '../river_pods/river_pod.dart';

class SignUpModel extends ChangeNotifier {
  final emailController =
      TextEditingController(text: 'yuta.nanana.tennis@gmail.com');
  final passController = TextEditingController(text: '03Yuta16');
  final nameController = TextEditingController(text: '五影 裕太');
  final birthDayController = TextEditingController();
  final telephoneNumberController =
      TextEditingController(text: '090-1964-5524');

  DateTime? dates;

  ///cupertinoPicker 生年月日
  Future<void> birthDayPicker(BuildContext context) async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1920, 3, 5),
        maxTime: DateTime.now(), onChanged: (date) {
      null;
    }, onConfirm: (date) {
      birthDayController.text = '${date.year}年${date.month}月${date.day}日';
      dates = date;
      notifyListeners();
    },
        currentTime: birthDayController.text.isEmpty ? DateTime.now() : dates,
        locale: LocaleType.jp);
  }

  ///signUpMethod
  Future<void> signUpTransition(BuildContext context, WidgetRef ref) async {
    final loading = ref.watch(loadingProvider.notifier).state;
    loading.startLoading();
    print(loading.isLoading);
    notifyListeners();

    try {
      if (emailController.text.isEmpty ||
          passController.text.isEmpty ||
          nameController.text.isEmpty ||
          birthDayController.text.isEmpty ||
          telephoneNumberController.text.isEmpty) {
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
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      await FirebaseFirestore.instance.collection('users').add({
        'uid': userCredential.user!.uid,
        'email': emailController.text,
        'name': nameController.text,
        'birthDay': birthDayController.text,
        'telephoneNumber': telephoneNumberController.text
      });
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
      loading.endLoading();
      print(loading.isLoading);

      notifyListeners();
    }
  }
}
