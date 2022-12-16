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
      'afterPrice': '¥11,000',
      'beforePrice': '¥14,800',
      'isTargetAllMember': false,
      'treatmentDetail': 'カット+コスメパーマ+システムトリートメント¥14800→¥11000～',
      'treatmentDetailList': ['カット', 'パーマ', 'トリートメント'],
      'menuIntroduction':
          '【新規様】カット+コスメパーマ+システムトリートメント¥11000～ロング料金別途必要。コスメパーマで髪に優しく、トリートメントでしっかり潤いを与えながらパーマを当てましょう。',
      'menuImageUrl':
          'https://s3-ap-northeast-1.amazonaws.com/images.smart-reception.jp/shops/4628/medias/cb62c2ffb70f441a12817ebccc6f747be706d8f6.jpg',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                addMenu();
              },
              child: const Text('このボタンから追加'))
        ],
      ),
    );
  }
}
