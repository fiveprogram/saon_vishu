import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/menu.dart';

class MenuModel extends ChangeNotifier {
  List<Menu> menuList = [];
  List<Menu> filteredMenuList = [];
  List<String> filteredTreatmentTypeList = [];
  List<String> treatmentTypeList = [
    'すべて',
    'カット',
    'カラー',
    'トリートメント',
    'パーマ',
    'ヘッドスパ',
    '縮毛矯正'
  ];

  //fetchMenuList
  Future<void> fetchMenuList() async {
    Stream<QuerySnapshot> menuStream = FirebaseFirestore.instance
        .collection('menu')
        .orderBy('priority', descending: false)
        .orderBy('afterPrice', descending: false)
        .snapshots();

    menuStream.listen((snapshot) {
      menuList = snapshot.docs.map((DocumentSnapshot doc) {
        return Menu.fromFireStore(doc);
      }).toList();

      notifyListeners();
    });
  }

  int? treatmentListIndex = 0;
  //カット条件のフィルタリング
  void filteringMenuList(int index) {
    filteredTreatmentTypeList.clear();
    filteredMenuList.clear();

    filteredTreatmentTypeList.add(treatmentTypeList[index]);
    treatmentListIndex = index;
    for (String treatment in filteredTreatmentTypeList) {
      for (Menu menu in menuList) {
        if (menu.treatmentDetailList.contains(treatment)) {
          filteredMenuList.add(menu);
        }
      }
    }
    notifyListeners();
  }

  void deletingFilteringMenuList(String name) {
    treatmentListIndex = null;
    for (Menu menu in menuList) {
      if (menu.treatmentDetailList.contains(name)) {
        filteredMenuList.remove(menu);
      }
    }
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('本当にログアウトしますか？'),
            actions: [
              CupertinoButton(
                  child: const Text('いいえ'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                  child: const Text('はい'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
