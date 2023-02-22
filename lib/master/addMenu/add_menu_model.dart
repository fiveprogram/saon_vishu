import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_vishu/domain/menu.dart';

class AddMenuModel extends ChangeNotifier {
  List<Menu> allMenuList = [];
  List<Menu> filteredDefaultMenuList = [];
  List<Menu> filteredCouponMenuList = [];

  String treatmentType = '';
  List<String> treatmentTypeList = [
    'すべて',
    'カット',
    'クーポン',
    'カラー',
    'パーマ',
    '縮毛矯正',
    'トリートメント',
    'ヘッドスパ',
    'ヘアセット',
    '着付け',
  ];

  //fetchMenuList
  Future<void> fetchMenuList() async {
    print(1);
    Stream<QuerySnapshot> menuStream = FirebaseFirestore.instance
        .collection('menu')
        .orderBy('priority', descending: false)
        .orderBy('afterPrice', descending: false)
        .snapshots();

    menuStream.listen((snapshot) {
      allMenuList = snapshot.docs.map((DocumentSnapshot doc) {
        return Menu.fromFireStore(doc);
      }).toList();

      notifyListeners();
    });
  }

  int? treatmentListIndex = 0;
  //カット条件のフィルタリング
  void filteringMenuList(int index) {
    treatmentType = '';
    filteredDefaultMenuList.clear();
    filteredCouponMenuList.clear();

    treatmentType = treatmentTypeList[index];
    treatmentListIndex = index;

    for (Menu menu in allMenuList) {
      if (menu.treatmentDetailList.first == treatmentType &&
          menu.treatmentDetailList.length == 1) {
        filteredDefaultMenuList.add(menu);
      } else if (menu.beforePrice != null && treatmentType == 'クーポン') {
        filteredCouponMenuList.add(menu);
      }
    }
    notifyListeners();
  }

  void deletingFilteringMenuList() {
    treatmentListIndex = null;
    filteredDefaultMenuList.clear();
    filteredCouponMenuList.clear();

    notifyListeners();
  }

  Future<void> menuDelete(Menu menu, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('このメニューを削除しても良いですか？'),
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
                await FirebaseFirestore.instance
                    .collection('menu')
                    .doc(menu.menuId)
                    .delete();

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
