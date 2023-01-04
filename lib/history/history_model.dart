import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../domain/menu.dart';
import '../domain/reservation.dart';

class HistoryModel extends ChangeNotifier {
  List<Menu> menuList = [];
  List<Menu> myHistoryList = [];
  List<Reservation> reservationList = [];

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
}
