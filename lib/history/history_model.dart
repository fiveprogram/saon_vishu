import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../domain/reservation.dart';

class HistoryModel extends ChangeNotifier {
  List<Reservation> reservationList = [];

  ///状況を整理していきたいと思う
  ///履歴のlistをどのように埋めているかというと、
  ///menuListとReservationを上から照合していく
  ///一致した順番にListに放り込んでいく

  final historyDateFormatter = DateFormat('yyyy年M月d日 H時mm分~');

  Future<void> fetchReservationList() async {
    User? user = FirebaseAuth.instance.currentUser;
    Stream<QuerySnapshot> reservationStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('reservations')
        .orderBy('startTime', descending: false)
        .snapshots();
    reservationStream.listen((snapshot) {
      reservationList = snapshot.docs
          .map((DocumentSnapshot doc) => Reservation.fromFirestore(doc))
          .toList();
      notifyListeners();
    });
  }

  ///menuCardの中で新規と
  Widget targetCard(Reservation reservation) {
    HexColor targetColor(String targetMember) {
      switch (targetMember) {
        case '新規':
          return HexColor('#344eba');
        case '再来':
          return HexColor('#73e600');
        case '全員':
          return HexColor('#e28e7a');
        default:
          return HexColor('#ff8db4');
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
