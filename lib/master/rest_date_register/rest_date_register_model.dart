import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:salon_vishu/master/schedule/schedule_page.dart';

import '../../domain/business_hours.dart';
import '../../domain/reservation.dart';
import '../../domain/rest.dart';

class RestDateRegisterModel extends ChangeNotifier {
  DateTime today = DateTime.now();
  int previousWeek = 0;

  DateFormat dayOfWeekFormatter = DateFormat('EE', 'ja_JP');

  ///カレンダーを表示する上で、１週間先の日時を取得する。
  ///ページが遷移すれば、previousWeeksの値の変化に伴い、返り値が変わる。
  DateTime currentDisplayDate() {
    return today.add(Duration(days: -7 * previousWeek));
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
    ///以下のどちらかでないと予約はできない。
    ///１つでも満たしていれば予約可能な条件の余事象
    for (final reservation in reservationList) {
      if (!(endTime.isBefore(reservation.startTime.toDate()) ||
          endTime.isAtSameMomentAs(reservation.startTime.toDate()) ||
          startTime.isAfter(reservation.finishTime.toDate()) ||
          startTime.isAtSameMomentAs(reservation.finishTime.toDate()))) {
        return false;
      }
    }

    return true;
  }

  ///休みたい日時を入れるリスト
  List<Rest> restTimeList = [];

  ///ローカル上trueとfalseを制御するだけのbool

  bool localAvailable = true;

  ///Restに追加するために情報をまとめたリスト
  void addRestTimeList(DateTime thirtyMinute) {
    final startTime = thirtyMinute;
    final endTime = thirtyMinute.add(const Duration(minutes: 30));
    final rest =
        Rest(Timestamp.fromDate(startTime), Timestamp.fromDate(endTime));

    Rest? removeTargetRestTime;
    for (final restTime in restTimeList) {
      if (restTime.startTime.toDate().isAtSameMomentAs(thirtyMinute)) {
        removeTargetRestTime = restTime;
      }
    }
    if (removeTargetRestTime == null) {
      restTimeList.add(rest);
    } else {
      restTimeList.remove(removeTargetRestTime);
    }
    notifyListeners();
  }

  ///表示を制御している
  String canRestTime(DateTime thirtyMinute) {
    fetchRestList();
    if (isAvailable(thirtyMinute) == false) {
      return '予';
    }
    if (registeredRestList.isNotEmpty) {
      for (var rest in registeredRestList) {
        restTimeList.add(rest);
      }
    }
    Rest? removeTargetRestTime;
    for (final restTime in restTimeList) {
      if (restTime.startTime.toDate().isAtSameMomentAs(thirtyMinute)) {
        removeTargetRestTime = restTime;
      }
    }
    if (removeTargetRestTime != null) {
      return '✖︎';
    } else {
      return '○';
    }
  }

  ///予約一覧
  List<Reservation> reservationList = [];
  List<Rest> registeredRestList = [];

  Future<void> fetchRestList() async {
    Stream<QuerySnapshot> restStream =
        FirebaseFirestore.instance.collectionGroup('rests').snapshots();

    restStream.listen(
      (snapshot) {
        registeredRestList = snapshot.docs
            .map((DocumentSnapshot doc) => Rest.fromFirestore(doc))
            .toList();
        notifyListeners();
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
        notifyListeners();
      },
    );
  }

  Future<void> registerRestTime(BuildContext context) async {
    for (var rest in restTimeList) {
      await FirebaseFirestore.instance
          .collection('rests')
          .add({'startTime': rest.startTime, 'endTime': rest.endTime});
    }
  }

  ///Registerモデル
  Future<void> registerRestOwnerTime(BuildContext context) async {
    if (restTimeList.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('入力がありません'),
            actions: [
              CupertinoButton(
                  child: const Text('戻る'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        },
      );
    }
    if (restTimeList.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('登録を完了しますか？'),
            actions: [
              CupertinoButton(
                  child: const Text('戻る'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                child: const Text('完了'),
                onPressed: () async {
                  registerRestTime(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SchedulePage()),
                      (route) => false);
                },
              ),
            ],
          );
        },
      );
    }
  }

  ///前のページに戻る
  Future<bool> willPopCallback(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('登録を中止しますか？'),
            content: const Text('登録した内容は破棄されます'),
            actions: [
              CupertinoButton(
                  child: const Text('いいえ'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
              CupertinoButton(
                  child: const Text('はい'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SchedulePage()),
                        (route) => false);
                  }),
            ],
          );
        });
  }
}
