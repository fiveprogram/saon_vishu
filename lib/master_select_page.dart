import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/master/master_model.dart';

class MasterSelectPage extends StatefulWidget {
  const MasterSelectPage({Key? key}) : super(key: key);

  @override
  State<MasterSelectPage> createState() => _MasterSelectPageState();
}

class _MasterSelectPageState extends State<MasterSelectPage> {
  List<Widget> masterPageList = [Text(''), Text('')];
  int masterPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vishuAppBar(appBarTitle: '管理者ページ', isJapanese: true),
      body: masterPageList[masterPageIndex],
      bottomNavigationBar: BottomNavigationBar(
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
