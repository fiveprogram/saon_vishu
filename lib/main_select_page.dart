import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:salon_vishu/profile/profile_page.dart';

import 'history/history_page.dart';
import 'menu/menu_page.dart';

// ignore: must_be_immutable
class MainSelectPage extends StatefulWidget {
  const MainSelectPage({Key? key}) : super(key: key);

  @override
  State<MainSelectPage> createState() => _MainSelectPageState();
}

class _MainSelectPageState extends State<MainSelectPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String tokenId = "";

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    // アプリ初期化時に画面にtokenを表示
    firebaseMessaging.getToken().then((String? token) {
      setState(() {
        tokenId = token!;
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('deviceTokenId')
          .doc(tokenId)
          .set({'deviceId': tokenId});

      print('オッパ');
    });
  }

  int currentPageIndex = 0;
  List<Widget> pageList = [
    const MenuPage(),
    const HistoryPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPageIndex,
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'メニュー'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: '履歴'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          ]),
    );
  }
}
