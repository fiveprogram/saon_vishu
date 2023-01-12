import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../domain/reservation.dart';

class BookerModel extends ChangeNotifier {
  List<Reservation> reservationList = [];

  final historyDateFormatter = DateFormat('yyyy年M月d日 H時mm分~');

  Future<void> fetchReservationList() async {
    Stream<QuerySnapshot> reservationStream = FirebaseFirestore.instance
        .collectionGroup('reservations')
        .orderBy('startTime', descending: false)
        .snapshots();

    reservationStream.listen(
      (snapshot) {
        reservationList = snapshot.docs
            .map((DocumentSnapshot doc) => Reservation.fromFirestore(doc))
            .toList();

        notifyListeners();
      },
    );
  }

  ///menuCardの中で新規と
  Widget targetCard(Reservation reservation) {
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
        color: targetColor(reservation.targetMember),
        border: Border.all(
          color: targetColor(reservation.targetMember),
        ),
      ),
      child: Center(
        child: Text(
          reservation.targetMember,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
