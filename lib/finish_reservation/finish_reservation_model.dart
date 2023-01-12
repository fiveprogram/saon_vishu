import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../domain/menu.dart';

class FinishReservationModel extends ChangeNotifier {
  ///menuCardの中で新規と
  Widget targetCard(Menu menu) {
    HexColor targetColor(String targetMember) {
      switch (targetMember) {
        case '新規':
          return HexColor('#344eba');
        case '再来':
          return HexColor('#7a3425');
        case '全員':
          return HexColor('#e28e7a');
        default:
          return HexColor('#e28e7a');
      }
    }

    return Container(
      width: 50,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        color: targetColor(menu.targetMember!),
        border: Border.all(
          color: targetColor(menu.targetMember!),
        ),
      ),
      child: Center(
        child: Text(
          menu.targetMember!,
          style: const TextStyle(color: Colors.white, fontSize: 12),
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
