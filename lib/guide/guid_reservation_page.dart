import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common_widget/vishu_app_bar.dart';

class GuideReservationPage extends StatefulWidget {
  const GuideReservationPage({Key? key}) : super(key: key);

  @override
  State<GuideReservationPage> createState() => _GuideReservationPageState();
}

class _GuideReservationPageState extends State<GuideReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'guide'),
    );
  }
}
