import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../domain/business_hours.dart';
import '../../domain/reservation.dart';
import '../../domain/rest.dart';

class ScheduleModel extends ChangeNotifier {
  DateTime today = DateTime.now();
  int previousWeek = 0;

  DateFormat dayOfWeekFormatter = DateFormat('EE', 'ja_JP');

  ///カレンダーを表示する上で、１週間先の日時を取得する。
  ///ページが遷移すれば、previousWeeksの値の変化に伴い、返り値が変わる。
  DateTime currentDisplayDate() {
    return today.add(Duration(days: -7 * previousWeek));
  }

  List<DateTime> holidayList = [];
  Future<void> getHolidayList() async {
    try {
      final dio = Dio();
      final url = Uri.parse('https://holidays-jp.github.io/api/v1/date.json');
      final response = await dio.getUri(url);

      Map<String, dynamic> map = jsonDecode(response.toString());
      final holidayStringList = map.keys.toList();
      holidayList = holidayStringList.map((e) => DateTime.parse(e)).toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  ///曜日によって色を帰るメソッド
  HexColor dowBoxColor(String dow, DateTime holidayCheck) {
    final holidayFormatter = DateFormat('yyyyMd');
    switch (dow) {
      case '土':
        return HexColor('#90caf9');
      case '日':
        return HexColor('#f7d9db');
    }

    for (final holiday in holidayList) {
      if (holidayFormatter.format(holiday).toString() ==
          holidayFormatter.format(holidayCheck).toString()) {
        return HexColor('#f7d9db');
      }
    }
    return HexColor('#e1e1e1');
  }

  ///weekDayList
  List<DateTime> weekDayList(DateTime date) {
    List<DateTime> weekList = [];
    for (var i = 0; i < 7; i++) {
      weekList.add(date.add(Duration(days: i)));
    }
    return weekList;
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
    result.removeLast();
    return result;
  }

  ///時間の形を整えるformatter
  final businessTimeFormatter = DateFormat('HH :mm');

  ///引数で与えるのはweekDay
  bool isAvailable(DateTime date) {
    final startTime = date;
    final endTime = startTime.add(const Duration(minutes: 1));

    //現在時刻より前は予約できない。
    if (startTime.isBefore(today)) {
      return false;
    }
    //営業終了時間
    final closeTime = DateTime(startTime.year, startTime.month, startTime.day,
        businessHour.closeTimeHour, businessHour.closeTimeMinute);

    //施術終了時間が営業終了時間よりも遅くなる場合は予約できない。
    if (endTime.isAfter(closeTime)) {
      return false;
    }

    ///以下のどちらかでないと予約はできない。

    for (final reservation in reservationList) {
      if (!(endTime.isBefore(reservation.startTime.toDate()) ||
          endTime.isAtSameMomentAs(reservation.startTime.toDate()) ||
          startTime.isAfter(reservation.finishTime.toDate()) ||
          startTime.isAtSameMomentAs(reservation.finishTime.toDate()))) {
        return false;
      }
    }

    //店主の指定した休憩時間。↑と同様のロジックを使用。
    for (final rest in restList) {
      if (!(endTime.isBefore(rest.startTime.toDate()) ||
          endTime.isAtSameMomentAs(rest.startTime.toDate()) ||
          startTime.isAfter(rest.endTime.toDate()) ||
          startTime.isAtSameMomentAs(rest.endTime.toDate()))) {
        return false;
      }
    }

    return true;
  }

  ///予約一覧
  List<Reservation> reservationList = [];
  List<Rest> restList = [];

  Timestamp nowTime = Timestamp.fromDate(DateTime.now());

  Future<void> fetchRestList() async {
    Stream<QuerySnapshot> restStream = FirebaseFirestore.instance
        .collectionGroup('rests')
        .where('startTime', isGreaterThan: nowTime)
        .snapshots();

    restStream.listen(
      (snapshot) {
        restList = snapshot.docs
            .map((DocumentSnapshot doc) => Rest.fromFirestore(doc))
            .toList();

        notifyListeners();
      },
    );
  }

  ///データベースから予約
  ///全員の予約履歴から参照
  Future<void> fetchReservationList() async {
    Stream<QuerySnapshot> reservationStream = FirebaseFirestore.instance
        .collectionGroup('reservations')
        .where('startTime', isGreaterThan: nowTime)
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
}
