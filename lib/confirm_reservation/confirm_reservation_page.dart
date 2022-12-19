import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';

class ConfirmReservationPage extends StatefulWidget {
  const ConfirmReservationPage({Key? key}) : super(key: key);

  @override
  State<ConfirmReservationPage> createState() => _ConfirmReservationPageState();
}

class _ConfirmReservationPageState extends State<ConfirmReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'reserve'),
      body: Consumer(
        builder: (context, model, child) {
          return Column(
            children: [],
          );
        },
      ),
    );
  }
}
