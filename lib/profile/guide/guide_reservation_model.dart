import 'package:flutter/material.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';

class GuideReservationModel extends StatefulWidget {
  const GuideReservationModel({Key? key}) : super(key: key);

  @override
  State<GuideReservationModel> createState() => _GuideReservationModelState();
}

class _GuideReservationModelState extends State<GuideReservationModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vishuAppBar(appBarTitle: '予約方法', isJapanese: true),
    );
  }
}
