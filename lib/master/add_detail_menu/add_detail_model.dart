import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon_vishu/domain/menu.dart';

class AddDetailModel extends ChangeNotifier {
  AddDetailModel(Menu? menu) {
    if (menu != null) {
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
      isNeedExtraMoney = menu.isNeedExtraMoney;
      isCallable = menu.isCallable;
    }
  }

  Menu? menu;
  final treatmentDetailController = TextEditingController();
  final beforePriceController = TextEditingController();
  final afterPriceController = TextEditingController();
  final menuIntroductionController = TextEditingController();
  final treatmentTimeController = TextEditingController();
  String? imgUrl;
  String? menuId;
  int? priority;

  bool? isCallable;
  bool isNeedExtraMoney = false;
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
    'パーマ',
    '縮毛矯正',
    'トリートメント',
    'ヘッドスパ',
    'ヘアセット',
    '着付け',
  ];
  List selectedTypeList = <String>[];

  final focusNode = FocusNode();

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
      if (selectedTypeList == [] ||
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
            builder: (dialogContext) {
              return CupertinoAlertDialog(
                title: const Text('登録してもよろしいですか？'),
                content: const Text('反映されるまで時間がかかる\n場合があります。'),
                actions: [
                  CupertinoButton(
                    child: const Text('いいえ'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(false);
                    },
                  ),
                  CupertinoButton(
                    child: const Text('はい'),
                    onPressed: () async {
                      startLoading();
                      print(isLoading);
                      if (file == null && imgUrl == null) {
                        return await showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text('未入力の項目があります'),
                              actions: [
                                CupertinoButton(
                                    child: const Text('戻る'),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(false);
                                    })
                              ],
                            );
                          },
                        );
                      }

                      ///もともとメニューがあり、画像の変更を行わない場合
                      if (file == null && imgUrl != null) {
                        print('もともとメニューがあり、画像の変更を行わない場合');
                        await FirebaseFirestore.instance
                            .collection('menu')
                            .doc(menuId)
                            .set(
                          {
                            'treatmentDetailList': selectedTypeList,
                            'treatmentDetail': treatmentDetailController.text,
                            'afterPrice': int.parse(afterPriceController.text),
                            'beforePrice': beforePriceController.text.isEmpty
                                ? null
                                : int.parse(beforePriceController.text),
                            'treatmentTime':
                                int.parse(treatmentTimeController.text),
                            'priority': priority,
                            'menuIntroduction': menuIntroductionController.text,
                            'menuImageUrl': imgUrl,
                            'menuId': menuId,
                            'isNeedExtraMoney': isNeedExtraMoney,
                            'isCallable': isCallable ?? false,
                          },
                        );
                      }

                      ///もともとメニューがあり、画像の変更したい場合
                      if (file != null && imgUrl != null) {
                        print('もともと画像が用意されており、且つ画像を変更したい場合');
                        final task = await FirebaseStorage.instance
                            .ref(
                                'menu/${FirebaseFirestore.instance.collection('menu').doc().id}')
                            .putFile(file!);
                        imgUrl = await task.ref.getDownloadURL();

                        await FirebaseFirestore.instance
                            .collection('menu')
                            .doc(menuId)
                            .update({
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
                          'priority': priority,
                          'isNeedExtraMoney': isNeedExtraMoney,
                          'menuId': menuId,
                          'isCallable': isCallable ?? false,
                        });
                      }

                      ///新規で作成される場合
                      if (file != null && imgUrl == null) {
                        print('新規で作成される場合');

                        final task = await FirebaseStorage.instance
                            .ref(
                                'menu/${FirebaseFirestore.instance.collection('menu').doc().id}')
                            .putFile(file!);
                        imgUrl = await task.ref.getDownloadURL();

                        final result = await FirebaseFirestore.instance
                            .collection('menu')
                            .add({
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
                          'isNeedExtraMoney': isNeedExtraMoney,
                          'isCallable': isCallable ?? false,
                        });

                        await FirebaseFirestore.instance
                            .collection('menu')
                            .doc(result.id)
                            .update({'menuId': result.id});
                      }

                      notifyListeners();
                      Navigator.pop(dialogContext);

                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
    } finally {
      endLoading();
      print(isLoading);
    }
    notifyListeners();
  }

  ///前のページに戻る
  Future<bool> willPopCallback(BuildContext context) async {
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
}
