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
      'afterPrice': '23,000',
      'beforePrice': '¥26,000',
      'isTargetAllMember': true,
      'treatmentDetail': '★髪質改善★酸性縮毛矯正+ハーブカラー+カット+システムTR￥26000→¥23000～',
      'treatmentDetailList': ['カット', 'カラー', '縮毛矯正', 'トリートメント'],
      'menuIntroduction':
          '髪質改善★酸性縮毛矯正+カラー+カット+システムTR￥23000～ロング料金別途必要。自然なストレートとシステムTRで触りたくなるツヤ髪へハーブカラーで低刺激なのでまとめて全部出来ちゃう♪',
      'menuImageUrl':
          'https://firebasestorage.googleapis.com/v0/b/salon-vishu.appspot.com/o/スクリーンショット%202022-12-17%2018.36.17.png?alt=media&token=994627ae-9b18-4636-b3c2-bb47ee47c438',
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
