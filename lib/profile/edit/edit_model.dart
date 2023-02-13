import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/profile.dart';

class EditModel extends ChangeNotifier {
  Profile profile;
  EditModel({required this.profile}) {
    nameController.text = profile.name;
    telephoneNumberController.text = profile.telephoneNumber;
    dateOfBirthController.text = profile.dateOfBirth;
    gender = profile.gender;
  }

  User? user = FirebaseAuth.instance.currentUser;
  String? errorText;
  String? gender;

  final focusNode = FocusNode();

  final nameController = TextEditingController();
  final telephoneNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  ///前のページに戻る
  Future<bool> willPopCallback(BuildContext context) async {
    ///あとで、registeredRestListの要素が減っていなければっていう制御も必要
    return await showDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('登録を中止しますか？'),
          content: const Text('登録した内容は破棄されます'),
          actions: [
            CupertinoButton(
                child: const Text('いいえ'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                }),
            CupertinoButton(
              child: const Text('はい'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  ///loading
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    return notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    return notifyListeners();
  }

  DateTime? registerDateOfBirth;

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
        currentTime: dateOfBirthController.text == ''
            ? DateTime(1980, 1, 1)
            : registerDateOfBirth,
        locale: LocaleType.jp);
  }

  ///写真の選択
  final ImagePicker _picker = ImagePicker();
  File? file;
  Future getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }
    file = File(image.path);
    notifyListeners();
  }

  Future getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    file = File(image.path);
    notifyListeners();
  }

  ///写真の登録
  Future<void> registerAccountPhoto(BuildContext context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          '写真を選択',
          style: TextStyle(fontSize: 18),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              getImageFromCamera();
              notifyListeners();
            },
            child: const Text('写真を撮る'),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              getImageFromGallery();
              notifyListeners();
            },
            child: const Text('カメラロールから選択'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
    notifyListeners();
  }

  ///完了ボタン
  Future<void> editProfileInformation(BuildContext context) async {
    final usersPath =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    startLoading();

    ///最低限入力項目
    try {
      if (nameController.text == '' ||
          dateOfBirthController.text == '' ||
          telephoneNumberController.text == '' ||
          gender == '') {
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
        endLoading();
        return;
      }
      if (file == null) {
        await usersPath.update({
          'name': nameController.text,
          'telephoneNumber': telephoneNumberController.text,
          'dateOfBirth': dateOfBirthController.text,
          'imgUrl': profile.imgUrl,
          'uid': user!.uid,
          'gender': gender,
          'dateTime': profile.dateTime
        });
      }
      if (file != null) {
        final task = await FirebaseStorage.instance
            .ref(
                'users/${FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('profiles').doc().id}')
            .putFile(file!);
        final imgUrl = await task.ref.getDownloadURL();

        await usersPath.update({
          'name': nameController.text,
          'telephoneNumber': telephoneNumberController.text,
          'dateOfBirth': dateOfBirthController.text,
          'imgUrl': imgUrl,
          'dateTime': profile.dateTime,
          'gender': gender,
          'uid': user!.uid,
        });

        notifyListeners();
      }
      Navigator.pop(context);
    } finally {
      endLoading();
    }
  }
}
