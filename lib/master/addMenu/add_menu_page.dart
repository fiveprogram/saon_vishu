import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/master/addMenu/add_menu_model.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({Key? key}) : super(key: key);

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddMenuModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: vishuAppBar(appBarTitle: 'メニュー追加'),
        body: Column(
          children: [],
        ),
      );
    });
  }
}
