import 'package:cloud_firestore/cloud_firestore.dart';
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
    'パーマ',
    'トリートメント',
    'ヘッドスパ',
    '縮毛矯正',
    '着付け'
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
}
