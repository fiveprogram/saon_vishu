import 'package:flutter/material.dart';
import 'package:salon_vishu/profile/profile_page.dart';

import 'history/history_page.dart';
import 'menu/menu_page.dart';

class MainSelectPage extends StatefulWidget {
  const MainSelectPage({Key? key}) : super(key: key);

  @override
  State<MainSelectPage> createState() => _MainSelectPageState();
}

class _MainSelectPageState extends State<MainSelectPage> {
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: '履歴'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'プロフィール'),
          ]),
    );
  }
}
