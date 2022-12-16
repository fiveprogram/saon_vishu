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
      'afterPrice': '',
      'beforePrice': '',
      'isTargetAllMember': true,
      'treatmentDetail': '',
      'treatmentDetailList': ['', ''],
      'menuIntroduction': '',
      'menuImageUrl': '',
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
