import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../domain/menu.dart';
import '../domain/profile.dart';

class SelectReservationDateModel extends ChangeNotifier {
  Menu menu;
  SelectReservationDateModel(this.menu);

  List<Widget> contentsOfHairList() {
    return menu.treatmentDetailList.map((treatmentDetail) {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: HexColor('#7e796e'),
            border: Border.all(
              color: HexColor('#7e796e'),
            ),
          ),
          child: Text(
            treatmentDetail,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    }).toList();
  }

  //対象者を表す
  Widget targetCard() {
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
}
