import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon_vishu/domain/menu.dart';
import 'package:salon_vishu/master/master_select_page.dart';

class AddDetailModel extends ChangeNotifier {
  AddDetailModel(Menu? menu) {
    if (menu != null) {
      print(file == null);
      targetMember = menu.targetMember;
      treatmentDetailController.text = menu.treatmentDetail;
      if (menu.beforePrice != null) {
        beforePriceController.text = menu.beforePrice.toString();
      }
      imgUrl = menu.menuImageUrl;
      menuId = menu.menuId;
      selectedTypeList = [...menu.treatmentDetailList];
      afterPriceController.text = menu.afterPrice.toString();
      menuIntroductionController.text = menu.menuIntroduction;
      treatmentTimeController.text = menu.treatmentTime.toString();
      priority = menu.priority;
    }
  }

  Menu? menu;
  String? targetMember;
  final treatmentDetailController = TextEditingController();
  final beforePriceController = TextEditingController();
  final afterPriceController = TextEditingController();
  final menuIntroductionController = TextEditingController();
  final treatmentTimeController = TextEditingController();
  String? imgUrl;
  String? menuId;
  int? priority;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  List<String> treatmentTypeList = [
    'カット',
    'カラー',
    'トリートメント',
    'パーマ',
    'ヘッドスパ',
    '縮毛矯正'
  ];
  List selectedTypeList = <String>[];

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
  Future<void> menuAddButton(BuildContext context) async {
    ///最低限入力項目
    try {
      if (targetMember == '' ||
          selectedTypeList == [] ||
          treatmentDetailController.text == '' ||
          afterPriceController.text == '' ||
          menuIntroductionController.text == '' ||
          treatmentTimeController.text == '') {
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
      } else {
        await showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('登録してもよろしいですか？'),
                actions: [
                  CupertinoButton(
                    child: const Text('いいえ'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoButton(
                    child: const Text('はい'),
                    onPressed: () async {
                      startLoading();
                      if (file == null && imgUrl == null) {
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
                          },
                        );
                      }

                      ///もともとメニューがある時
                      if (file == null && imgUrl != null) {
                        await FirebaseFirestore.instance
                            .collection('menu')
                            .doc(menuId)
                            .set(
                          {
                            'targetMember': targetMember,
                            'treatmentDetailList': selectedTypeList,
                            'treatmentDetail': treatmentDetailController.text,
                            'afterPrice': int.parse(afterPriceController.text),
                            'beforePrice': beforePriceController.text.isEmpty
                                ? null
                                : int.parse(beforePriceController.text),
                            'treatmentTime':
                                int.parse(treatmentTimeController.text),
                            'priority': 999,
                            'menuIntroduction': menuIntroductionController.text,
                            'menuImageUrl': imgUrl,
                            'menuId': menuId
                          },
                        );
                      }

                      if (file != null) {
                        final task = await FirebaseStorage.instance
                            .ref(
                                'menu/${FirebaseFirestore.instance.collection('menu').doc().id}')
                            .putFile(file!);
                        imgUrl = await task.ref.getDownloadURL();

                        final result = await FirebaseFirestore.instance
                            .collection('menu')
                            .add({
                          'targetMember': targetMember,
                          'treatmentDetailList': selectedTypeList,
                          'treatmentDetail': treatmentDetailController.text,
                          'afterPrice': int.parse(afterPriceController.text),
                          'beforePrice': beforePriceController.text.isEmpty
                              ? null
                              : int.parse(beforePriceController.text),
                          'treatmentTime':
                              int.parse(treatmentTimeController.text),
                          'menuIntroduction': menuIntroductionController.text,
                          'menuImageUrl': imgUrl,
                          'priority': 999,
                        });

                        await FirebaseFirestore.instance
                            .collection('menu')
                            .doc(result.id)
                            .update({'menuId': result.id});
                      }
                      notifyListeners();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MasterSelectPage()),
                          (route) => false);
                    },
                  ),
                ],
              );
            });
      }
    } finally {
      endLoading();
    }
    notifyListeners();
  }
}