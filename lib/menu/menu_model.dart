import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/menu.dart';

class MenuModel extends ChangeNotifier {
  List<Menu> menuList = [];

  //fetchMenuList
  Future<void> fetchMenuList() async {
    Stream<QuerySnapshot> menuStream =
        FirebaseFirestore.instance.collection('menu').snapshots();

    menuStream.listen((snapshot) {
      menuList = snapshot.docs.map((DocumentSnapshot doc) {
        return Menu.fromFireStore(doc);
      }).toList();
      notifyListeners();
    });
  }

  Future<void> signOut(BuildContext context) async {
    showDialog(
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
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  bool isFeePopUp = false;
  void startPopUp() {
    isFeePopUp = true;
    notifyListeners();
  }

  void endPopUp() {
    isFeePopUp = false;
    notifyListeners();
  }

  void popUpFeeList(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return Material(
          child: Container(
            height: 100,
            width: 300,
            child: const Text(
                '¥料金表\n大人カット ¥3,800\n大学生カット ¥3,500\n中学生・高校生カット ¥3,000\n幼稚園児・小学生カット ¥2,000\nフロントカット ¥5,00'),
            // actions: [
            //   CupertinoButton(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       child: const Text('OK'))
            // ],
          ),
        );
      },
    );
  }
}
