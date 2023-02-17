import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
}
