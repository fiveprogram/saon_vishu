import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon_vishu/domain/profile.dart';

class EditModel extends ChangeNotifier {
  Profile profile;
  EditModel({required this.profile}) {
    nameController.text = profile.name;
    telephoneNumberController.text = profile.telephoneNumber;
    emailController.text = profile.email;
    dateOfBirthController.text = profile.dateOfBirth;
  }

  User? user = FirebaseAuth.instance.currentUser;
  String? errorText;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telephoneNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();

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
    print('happy');
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
    notifyListeners();
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
  void registerAccountPhoto(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          '写真を選択',
          style: TextStyle(fontSize: 18),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              getImageFromGallery();
              notifyListeners();
            },
            child: const Text('カメラロールから選択'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              getImageFromCamera();
              notifyListeners();
            },
            child: const Text('写真を撮る'),
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
      if (emailController.text == '' ||
          nameController.text == '' ||
          dateOfBirthController.text == '' ||
          telephoneNumberController.text == '') {
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
      if (file == null) {
        await usersPath.update({
          'name': nameController.text,
          'email': emailController.text,
          'telephoneNumber': telephoneNumberController.text,
          'dateOfBirth': dateOfBirthController.text,
          'imgUrl': profile.imgUrl,
          'uid': user!.uid,
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
          'email': emailController.text,
          'telephoneNumber': telephoneNumberController.text,
          'dateOfBirth': dateOfBirthController.text,
          'imgUel': imgUrl,
          'dateTime': profile.dateTime,
          'uid': user!.uid,
        });
        print(imgUrl);

        notifyListeners();
      }
    } finally {
      endLoading();
      Navigator.pop(context);
    }
  }
}
