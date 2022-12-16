import 'package:flutter/material.dart';
import 'package:salon_vishu/domain/menu.dart';

// ignore: must_be_immutable
class SelectReservationDatePage extends StatefulWidget {
  Menu menu;
  SelectReservationDatePage({required this.menu, Key? key}) : super(key: key);

  @override
  State<SelectReservationDatePage> createState() =>
      _SelectReservationDatePageState();
}

class _SelectReservationDatePageState extends State<SelectReservationDatePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(),
    );
  }
}
