import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

///7カラー
///8パーマ
///9縮毛矯正
///10トリートメント
///11ワンランクアップトリートメント
///12ヘアセット
///13ヘッドスパ
///14着付け

///メニュー追加画面でヘアセット・着付けランを作っていない

class _AddPageState extends State<AddPage> {
  Future<void> addMenu() async {
    final result = await FirebaseFirestore.instance.collection('menu').add({
      'afterPrice': 2500,
      'targetMember': '全員',
      'treatmentDetail': '成人式 [ネット予約対象外]',
      'treatmentDetailList': ['着付け'],
      'menuIntroduction': '要予約。着付け、成人式ヘアセット、メイク。単品もございますのでお問い合わせ下さい。',
      'menuImageUrl':
          'https://firebasestorage.googleapis.com/v0/b/salon-vishu.appspot.com/o/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202023-01-18%2014.22.39.png?alt=media&token=f28b363f-5631-4a5d-b44b-3224fb9f2354',
      'menuId': '',
      'treatmentTime': 180,
      'isNeedExtraMoney': false,
      'priority': 14,
    });

    await FirebaseFirestore.instance.collection('menu').doc(result.id).update({
      'menuId': result.id,
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
                  addMenu();
                },
                child: const Text('追加')),
          )
        ],
      ),
    );
  }
}
