import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/history/history_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'history'),
      body: Consumer<HistoryModel>(
        builder: (context, model, child) {
          print(model.myHistoryList);

          return Column(
            children: [],
          );
        },
      ),
    );
  }
}
