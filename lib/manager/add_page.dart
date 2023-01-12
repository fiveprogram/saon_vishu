import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  Future<void> addMenu() async {
    await FirebaseFirestore.instance.collection('menu').add({
      'afterPrice': 'いつもオセ❽ないなテオリマtextフォさんフォmacあんふぉなそjfんさどjfな',
      'beforePrice': '',
      'isTargetAllMember': true,
      'treatmentDetail': 'フロントカット(シャンプー・ブロー込) 　イメージに合わせてカットします♪',
      'treatmentDetailList': ['カット'],
      'menuIntroduction': 'フロントカット 　イメージに合わせてカットします♪',
      'menuImageUrl':
          'https://firebasestorage.googleapis.com/v0/b/salon-vishu.appspot.com/o/スクリーンショット%202022-12-19%2014.40.07.png?alt=media&token=3decbe8c-d849-4f3e-8591-bb2c0a8ccb8a',
      'menuId': '',
    });
  }

  Future<void> addTime() async {
    await FirebaseFirestore.instance
        .collection('menu')
        .doc('6f8cBqIxDMJiN85R4OTA')
        .update({
      'priority': 999,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  addTime();
                },
                child: const Text('追加')),
          )
        ],
      ),
    );
  }
}
