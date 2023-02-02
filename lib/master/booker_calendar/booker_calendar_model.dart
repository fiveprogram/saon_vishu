import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:salon_vishu/domain/reservation.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../firebase_options.dart';

class BookerCalendarModel extends ChangeNotifier {
  CalendarFormat calendarFormat = CalendarFormat.month;
  final today = DateTime.now();

  DateTime? selectedDate;
  DateTime focusedDate = DateTime.now();
  DateFormat startTimeFormatter = DateFormat('HH:mm〜');
  DateFormat endTimeFormatter = DateFormat('HH:mm');
  DateFormat lastVisitFormatter = DateFormat('yyyy年M月d日');
  List<Reservation> reservationList = [];

  Future<void> fetchReservation() async {
    Stream<QuerySnapshot> reservationStream =
        FirebaseFirestore.instance.collectionGroup('reservations').snapshots();

    reservationStream.listen((snapshot) {
      reservationList = snapshot.docs
          .map((DocumentSnapshot doc) => Reservation.fromFirestore(doc))
          .toList();

      notifyListeners();
    });
  }

  List<Reservation> getEventsForDay(DateTime day) {
    List<Reservation> everyDayEvent = [];
    DateFormat reservationFormat = DateFormat('yyyyMMdd');

    everyDayEvent = reservationList
        .where((reservation) =>
            reservationFormat.format(reservation.startTime.toDate()) ==
            reservationFormat.format(day))
        .toList();

    return everyDayEvent;
  }

  String menuBlock(String menuName) {
    switch (menuName) {
      case 'カット':
        return 'C';
      case 'カラー':
        return 'L';
      case 'トリートメント':
        return 'T';
      case '縮毛矯正':
        return 'S';
      case 'パーマ':
        return 'P';
      case '髪の長さロング料金':
        return 'O';
      case 'Sa':
        return 'ヘアセット';
      default:
        return 'カット';
    }
  }

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

  Future<void> googleSignOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: DefaultFirebaseOptions.currentPlatform.iosClientId);
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }
  }

  Future<void> signOut(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('本当にログアウトしますか？'),
            actions: [
              CupertinoButton(
                  child: const Text('いいえ'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                  child: const Text('はい'),
                  onPressed: () async {
                    await googleSignOut();
                    await FirebaseAuth.instance.signOut();
                    notifyListeners();
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
