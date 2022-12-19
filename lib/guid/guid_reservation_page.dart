import 'package:flutter/material.dart';
import '../common_widget/vishu_app_bar.dart';

class GuidReservationPage extends StatefulWidget {
  const GuidReservationPage({Key? key}) : super(key: key);

  @override
  State<GuidReservationPage> createState() => _GuidReservationPageState();
}

class _GuidReservationPageState extends State<GuidReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'guid'),
    );
  }
}
