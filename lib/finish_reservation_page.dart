import 'package:flutter/material.dart';

class FinishReservationPage extends StatefulWidget {
  const FinishReservationPage({Key? key}) : super(key: key);

  @override
  State<FinishReservationPage> createState() => _FinishReservationPageState();
}

class _FinishReservationPageState extends State<FinishReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('要予約してくれましたわ'),
      ),
    );
  }
}
