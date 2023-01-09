import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/master/rest_edit/rest_edit_model.dart';

class RestEditPage extends StatefulWidget {
  const RestEditPage({Key? key}) : super(key: key);

  @override
  State<RestEditPage> createState() => _RestEditPageState();
}

class _RestEditPageState extends State<RestEditPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RestEditModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: vishuAppBar(appBarTitle: '休憩情報', isJapanese: true),
      );
    });
  }
}
