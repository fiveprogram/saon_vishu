import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../domain/business_hours.dart';
import '../domain/menu.dart';
import '../domain/profile.dart';
import '../domain/reservation.dart';
import '../domain/rest.dart';

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
    result.removeLast();
    return result;
  }

  ///時間の形を整えるformatter
  final businessTimeFormatter = DateFormat('HH :mm');

  ///予約できるための条件
  ///①現在の時刻よりも未来の時間であること。
  ///②始業時間より後、就業時間よりも前であること
  ///③現在予約されていないこと

  ///引数で与えるのはweekDay
  bool isAvailable(DateTime date, Menu menu) {
    final startTime = date;
    final endTime = startTime.add(Duration(minutes: menu.treatmentTime));

    ///今の時間よりも前の時間のマスは全て✖︎
    if (startTime.isBefore(today)) {
      return false;
    }

    ///毎日9時を指している
    final openTime = DateTime(date.year, date.month, date.day,
        businessHour.openTimeHour, businessHour.openTimeMinute);

    ///毎日9時より前に開始されているマスは全て✖︎
    if (startTime.isBefore(openTime)) {
      return false;
    }

    ///毎日18時を指している
    final closeTime = DateTime(date.year, date.month, date.day,
        businessHour.closeTimeHour, businessHour.closeTimeMinute);

    ///店が終わる時間よりも後の予約はできない
    if (endTime.isAfter(closeTime)) {
      return false;
    }

    for (final reservation in reservationList) {
      final a = reservation.startTime.toDate();
      final b =
          DateTime(a.year, a.month, a.day, startTime.hour, startTime.minute);

      // if (!(endTime.isBefore(reservation.startTime.toDate()))) {
      //   return false;
      // }
    }

    ///既に予約が入れられているマスを✖︎の表示にしたい
    ///施術時間に応じて◯と✖︎が変わります。
    // for (final reservation in reservationList) {
    //   print(reservation.finishTime.toDate());
    //
    //   ///予約開始時間よりあとに終了時間がきてしまっている
    //   if ((endTime.isAfter(reservation.startTime.toDate()) &&
    //
    //           ///予約の開始時刻と終了時刻が同時
    //           endTime.isAtSameMomentAs(reservation.startTime.toDate()) ||
    //
    //       ///予約が終わる時間よりも後に開始時刻がきていない
    //       ///開始時刻が予約の終了時間よりも前にきてしまっている。
    //       startTime.isBefore(reservation.finishTime.toDate()) ||
    //
    //       ///予約の終了時刻が開始時刻と同時になってしまっている。
    //       startTime.isAtSameMomentAs(reservation.finishTime.toDate()))) {
    //     return false;
    //   }
    // }

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
