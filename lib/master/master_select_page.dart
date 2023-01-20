import 'package:flutter/material.dart';
import 'package:salon_vishu/master/addMenu/add_menu_page.dart';
import 'package:salon_vishu/master/booker_calendar/booker_calendar_page.dart';
import 'package:salon_vishu/master/push_notification/push_notification_page.dart';

import 'schedule/schedule_page.dart';

class MasterSelectPage extends StatefulWidget {
  const MasterSelectPage({Key? key}) : super(key: key);

  @override
  State<MasterSelectPage> createState() => _MasterSelectPageState();
}

class _MasterSelectPageState extends State<MasterSelectPage> {
  List<Widget> masterPageList = [
    const SchedulePage(),
    const BookerCalendarPage(),
    const PushNotificationPage(),
    const AddMenuPage()
  ];
  int masterPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: masterPageList[masterPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 4,
          type: BottomNavigationBarType.fixed,
          currentIndex: masterPageIndex,
          onTap: (int index) {
            masterPageIndex = index;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: '予定'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '予約者一覧'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notification_add), label: 'プッシュ通知画面'),
            BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts), label: 'メニュー管理'),
          ]),
    );
  }
}
