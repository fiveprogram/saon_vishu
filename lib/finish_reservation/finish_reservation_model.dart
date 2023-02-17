import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../domain/menu.dart';

class FinishReservationModel extends ChangeNotifier {
  List<Widget> contentsOfHairList(Menu menu) {
    return menu.treatmentDetailList
        .map(
          (treatmentDetail) => Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: HexColor('#7a3425'),
                border: Border.all(
                  color: HexColor('#7a3425'),
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
