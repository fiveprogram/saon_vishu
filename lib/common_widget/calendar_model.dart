import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:salon_vishu/domain/business_hours.dart';
import 'package:salon_vishu/domain/reservation.dart';
import 'package:salon_vishu/domain/rest.dart';

import '../domain/profile.dart';

class CalendarModel extends ChangeNotifier {
  Profile? profile;

  Future<void> fetchProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    final profileStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots();

    profileStream.listen((snapshot) {
      profile = Profile.fromFirestore(snapshot);
      notifyListeners();
    });
  }

  DateTime today = DateTime.now();

  int thisWeek = 0;
  DateFormat dayOfWeekFormatter = DateFormat('EE', 'ja_JP');

  ///カレンダーを表示する上で、１週間先の日時を取得する。
  ///ページが遷移すれば、previousWeeksの値の変化に伴い、返り値が変わる。
  DateTime currentDisplayDate() {
    return today.add(Duration(days: 7 * thisWeek));
  }

  ///曜日によって色を帰るメソッド
  HexColor dowBoxColor(String dow) {
    switch (dow) {
      case '土':
        return HexColor('#90caf9');
      case '日':
        return HexColor('#f7d9db');
      default:
        return HexColor('#e1e1e1');
    }
  }

  ///１週間ごとの曜日を取得し、並列するlist
  List<DateTime> weekDateList(DateTime date) {
    final day = date.day;
    final result = <DateTime>[];

    for (int i = day; i < day + 7; i++) {
      result.add(date.add(Duration(days: i - day)));
    }
    return result;
  }

  ///営業時間の決め打ち
  final businessHour = const BusinessHours(9, 00, 18, 00);

  ///引数に与えるのはcurrentDisplayDate
  List<DateTime> separateThirtyMinutes(DateTime date) {
    //始業開始時間
    var businessStartTime = DateTime(date.year, date.month, date.day,
        businessHour.openTimeHour, businessHour.openTimeMinute);

    var businessCloseTime = DateTime(date.year, date.month, date.day,
        businessHour.closeTimeHour, businessHour.closeTimeMinute);
    final result = <DateTime>[businessStartTime];
    while (businessStartTime != businessCloseTime) {
      businessStartTime = businessStartTime.add(const Duration(minutes: 30));
      result.add(businessStartTime);
    }
    return result;
  }

  ///時間の形を整えるformatter
  final businessTimeFormatter = DateFormat('HH :mm');

  ///予約できるための条件
  ///①現在の時刻よりも未来の時間であること。
  ///②始業時間より後、就業時間よりも前であること
  ///③現在予約されていないこと

  ///引数で与えるのはweekDay
  bool isAvailable(DateTime date) {
    final startTime = date;
    final endTime = startTime.add(const Duration(minutes: 30));

    ///①の条件を満たしているか
    if (startTime.isBefore(today)) {
      return false;
    }

    ///②の始業時間の定義
    final openTime = DateTime(date.year, date.month, date.day,
        businessHour.openTimeHour, businessHour.openTimeMinute);

    if (startTime.isBefore(openTime)) {
      return false;
    }

    ///そもそも始業時間より前、終業時間よりあとはマスそのものが存在しないため、自動的にfalseな気がする
    // ///②の終業時間側
    // final closeTime = DateTime(date.year, date.month, date.day,
    //     businessHour.closeTimeHour, businessHour.closeTimeMinute);
    //
    // if (endTime.isAfter(closeTime)) {
    //   return false;
    // }

    ///条件が難しい
    ///既に予約が入れられているマスを✖︎の表示にしたい
    for (var reservation in reservationList) {
      if (startTime.isAfter(reservation.startTime.toDate()) &&
              endTime.isBefore(reservation.finishTime.toDate()) ||
          startTime.isAtSameMomentAs(reservation.startTime.toDate()) ||
          endTime.isAtSameMomentAs(reservation.finishTime.toDate())) {
        return false;
      }
    }

    ///既に休憩が入れられているマスを✖の表示にしたい
    for (var rest in restList) {
      if (startTime.isAfter(rest.startTime) && endTime.isBefore(rest.endTime) ||
          startTime.isAtSameMomentAs(rest.startTime) ||
          endTime.isAtSameMomentAs(rest.endTime)) {
        return false;
      }
    }
    return true;
  }

  ///予約一覧
  List<Reservation> reservationList = [];
  List<Rest> restList = [];

  Future<void> fetchRestList() async {
    Stream<QuerySnapshot> restStream =
        FirebaseFirestore.instance.collectionGroup('rests').snapshots();

    restStream.listen(
      (snapshot) {
        restList = snapshot.docs
            .map((DocumentSnapshot doc) => Rest.fromFirestore(doc))
            .toList();
      },
    );
  }

  ///データベースから予約
  ///全員の予約履歴から参照
  Future<void> fetchReservationList() async {
    Stream<QuerySnapshot> reservationStream =
        FirebaseFirestore.instance.collectionGroup('reservations').snapshots();

    reservationStream.listen(
      (snapshot) {
        reservationList = snapshot.docs
            .map((DocumentSnapshot doc) => Reservation.fromFirestore(doc))
            .toList();
      },
    );
  }
}
