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

  ///引数で与えるのはweekDay
  bool isAvailable(DateTime date, Menu menu) {
    final startTime = date;
    final endTime = startTime.add(Duration(minutes: menu.treatmentTime));

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
    //1. 予約する施術の終了時間が、既に予約を入れられている施術の終了時間よりも前(同時も含む)の場合。
    //-------------------------施術開始時間[予約済]-----施術終了時間[予約済]
    //-----施術終了時間[未予約]
    //2. 予約する施術の開始時間が、既に予約を入れられている施術の終了時間よりも後(同時も含む)の場合。
    //施術開始時間[予約済]-----施術終了時間[予約済]
    //----------------------------------------施術開始時間[未予約]----
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
      if (!(endTime.isBefore(rest.startTime) ||
          endTime.isAtSameMomentAs(rest.startTime) ||
          startTime.isAfter(rest.endTime) ||
          startTime.isAtSameMomentAs(rest.endTime))) {
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
