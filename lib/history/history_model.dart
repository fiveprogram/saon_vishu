import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../domain/menu.dart';
import '../domain/reservation.dart';

class HistoryModel extends ChangeNotifier {
  List<Menu> menuList = [];
  List<Menu> myHistoryList = [];
  List<Reservation> reservationList = [];

  final historyDateFormatter = DateFormat('yyyy年M月d日');

  Future<void> fetchMenuList() async {
    Stream<QuerySnapshot> menuStream =
        FirebaseFirestore.instance.collection('menu').snapshots();

    menuStream.listen((snapshot) {
      menuList = snapshot.docs.map((DocumentSnapshot doc) {
        return Menu.fromFireStore(doc);
      }).toList();
    });
    notifyListeners();
  }

  Future<void> addHistory() async {
    for (var menu in menuList) {
      for (var reservation in reservationList) {
        if (menu.menuId == reservation.menuId) {
          myHistoryList.add(menu);
        }
      }
    }
  }

  Future<void> fetchReservationList() async {
    User? user = FirebaseAuth.instance.currentUser;
    Stream<QuerySnapshot> reservationStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('reservations')
        .snapshots();
    reservationStream.listen((snapshot) {
      reservationList = snapshot.docs
          .map((DocumentSnapshot doc) => Reservation.fromFirestore(doc))
          .toList();
    });
    notifyListeners();
  }

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
}
