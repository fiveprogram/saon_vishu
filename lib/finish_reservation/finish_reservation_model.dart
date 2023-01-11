import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../domain/menu.dart';

class FinishReservationModel extends ChangeNotifier {
  Widget targetCard(Menu menu) {
    return menu.isTargetAllMember
        ? Container(
            width: 50,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: HexColor('#e28e7a'),
              border: Border.all(
                color: HexColor('#e28e7a'),
              ),
            ),
            child: const Center(
              child: Text(
                '全員',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          )
        : Container(
            width: 50,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: HexColor('#7a3425'),
              border: Border.all(
                color: HexColor('#7a3425'),
              ),
            ),
            child: const Center(
              child: Text(
                '新規',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          );
  }

  List<Widget> contentsOfHairList(Menu menu) {
    return menu.treatmentDetailList
        .map(
          (treatmentDetail) => Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: HexColor('#989593'),
                border: Border.all(
                  color: HexColor('#989593'),
                ),
              ),
              child: Text(
                treatmentDetail,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        )
        .toList();
  }

  final visitStoreFormatter = DateFormat('yyyy年M月d日 H時mm分~');
}
