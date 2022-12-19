import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  Future<void> addMenu() async {
    await FirebaseFirestore.instance.collection('menu').add({
      'afterPrice': '¥550',
      'beforePrice': '',
      'isTargetAllMember': true,
      'treatmentDetail': 'フロントカット(シャンプー・ブロー込) 　イメージに合わせてカットします♪',
      'treatmentDetailList': ['カット'],
      'menuIntroduction': 'フロントカット 　イメージに合わせてカットします♪',
      'menuImageUrl':
          'https://firebasestorage.googleapis.com/v0/b/salon-vishu.appspot.com/o/スクリーンショット%202022-12-19%2014.40.07.png?alt=media&token=3decbe8c-d849-4f3e-8591-bb2c0a8ccb8a',
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
                child: const Text('情報を追加する')),
          )
        ],
      ),
    );
  }
}
