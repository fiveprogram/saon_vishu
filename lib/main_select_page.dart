import 'package:flutter/material.dart';

class MainSelectPage extends StatefulWidget {
  const MainSelectPage({Key? key}) : super(key: key);

  @override
  State<MainSelectPage> createState() => _MainSelectPageState();
}

class _MainSelectPageState extends State<MainSelectPage> {
  int currentPageIndex = 0;
  List<Widget> pageList = [
    const Text(''),
    const Text(''),
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
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'メッセージ'),
          ]),
    );
  }
}
