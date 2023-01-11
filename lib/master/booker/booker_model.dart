import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:salon_vishu/domain/menu.dart';

import '../../domain/reservation.dart';

class BookerModel extends ChangeNotifier {
  List<Reservation> reservationList = [];
  List<Menu> menuList = [];
  List<Menu> bookerList = [];

  final historyDateFormatter = DateFormat('yyyy年M月d日');

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

        for (var menu in menuList) {
          for (var reservation in reservationList) {
            if (menu.menuId == reservation.menuId) {
              if (!bookerList.contains(menu)) {
                bookerList.add(menu);
              }
            }
          }

          for (int i = 0; i < bookerList.length; i++) {
            print(bookerList[i].menuId);
            print('${reservationList[i].menuId}おっぱ');
          }
        }

        notifyListeners();
      },
    );
  }

  //fetchMenuList
  Future<void> fetchMenuList() async {
    Stream<QuerySnapshot> menuStream =
        FirebaseFirestore.instance.collection('menu').snapshots();

    menuStream.listen((snapshot) {
      menuList = snapshot.docs.map((DocumentSnapshot doc) {
        return Menu.fromFireStore(doc);
      }).toList();
      notifyListeners();
    });
  }

  Future<void> addBookerList() async {
    for (var menu in menuList) {
      for (var reservation in reservationList) {
        if (menu.menuId == reservation.menuId) {
          if (!bookerList.contains(menu)) {
            bookerList.add(menu);
          }
        }
      }
    }
  }

  ///menuCardの中で新規と
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
