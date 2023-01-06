import 'package:flutter/material.dart';

import 'master/schedule/schedule_page.dart';

class MasterSelectPage extends StatefulWidget {
  const MasterSelectPage({Key? key}) : super(key: key);

  @override
  State<MasterSelectPage> createState() => _MasterSelectPageState();
}

class _MasterSelectPageState extends State<MasterSelectPage> {
  List<Widget> masterPageList = [const SchedulePage(), Text('')];
  int masterPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: masterPageList[masterPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 4,
          currentIndex: masterPageIndex,
          onTap: (int index) {
            masterPageIndex = index;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: '予定'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '予約者一覧')
          ]),
    );
  }
}
