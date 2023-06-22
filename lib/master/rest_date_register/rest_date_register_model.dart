import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:salon_vishu/master/master_select_page.dart';

import '../../domain/business_hours.dart';
import '../../domain/reservation.dart';
import '../../domain/rest.dart';

class RestDateRegisterModel extends ChangeNotifier {
  ///予約一覧
  List<Reservation> reservationList = [];

  ///データベースのRest情報
  List<Rest> alreadyRegisteredRestList = [];

  ///新規の
  List<Rest> willAddRegisteredRestList = [];

  ///これからRestから削除する情報
  List<Rest> willRemoveRegisteredRestList = [];

  Timestamp nowTime = Timestamp.fromDate(DateTime.now());

  Future<void> fetchRestList() async {
    Stream<QuerySnapshot> restStream = FirebaseFirestore.instance
        .collectionGroup('rests')
        .where('startTime', isGreaterThan: nowTime)
        .snapshots();

    restStream.listen(
      (snapshot) {
        alreadyRegisteredRestList = snapshot.docs
            .map((DocumentSnapshot doc) => Rest.fromFirestore(doc))
            .toList();

        ///過去文のrest情報を全て削除する
        for (final alreadyRegistered in alreadyRegisteredRestList) {
          if (alreadyRegistered.endTime.toDate().isBefore(today)) {
            FirebaseFirestore.instance
                .collection('rests')
                .doc(alreadyRegistered.restId)
                .delete();
          }
        }
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

  DateTime today = DateTime.now();
  int previousWeek = 0;

  DateFormat dayOfWeekFormatter = DateFormat('EE', 'ja_JP');

  ///カレンダーを表示する上で、１週間先の日時を取得する。
  ///ページが遷移すれば、previousWeeksの値の変化に伴い、返り値が変わる。
  DateTime currentDisplayDate() {
    return today.add(Duration(days: -7 * previousWeek));
  }

  final businessHour = const BusinessHours(9, 00, 18, 00);

  ///1日の休憩時間を30分おきに全て登録
  Future<void> registerAllDayRest(DateTime date) async {
    ///営業開始
    var businessStartTime = DateTime(date.year, date.month, date.day,
        businessHour.openTimeHour, businessHour.openTimeMinute);

    ///営業終了
    var businessCloseTime = DateTime(date.year, date.month, date.day,
        businessHour.closeTimeHour, businessHour.closeTimeMinute);

    ///30分おきに区切られた1日の時間枠
    final oneDaySeparateThirtyMinuteList = <DateTime>[businessStartTime];

    ///30分区切りの時間枠
    while (businessStartTime != businessCloseTime) {
      businessStartTime = businessStartTime.add(const Duration(minutes: 30));
      oneDaySeparateThirtyMinuteList.add(businessStartTime);
    }
    oneDaySeparateThirtyMinuteList.removeLast();

    ///30分おきに登録
    for (int i = 0; i < oneDaySeparateThirtyMinuteList.length; i++) {
      final idFormat = DateFormat('yyyyMMddhhmm');

      await FirebaseFirestore.instance
          .collection('rests')
          .doc(idFormat.format(oneDaySeparateThirtyMinuteList[i]))
          .set({
        'startTime': oneDaySeparateThirtyMinuteList[i],
        'endTime':
            oneDaySeparateThirtyMinuteList[i].add(const Duration(minutes: 30)),
        'restId': idFormat.format(oneDaySeparateThirtyMinuteList[i])
      });
    }
  }

  ///登録されてる1日分の休息を全て削除
  Future<void> allDayDelete(DateTime date) async {
    var businessStartTime = DateTime(date.year, date.month, date.day,
        businessHour.openTimeHour, businessHour.openTimeMinute);

    var businessCloseTime = DateTime(date.year, date.month, date.day,
        businessHour.closeTimeHour, businessHour.closeTimeMinute);

    final oneDaySeparateThirtyMinuteList = <DateTime>[businessStartTime];

    while (businessStartTime != businessCloseTime) {
      businessStartTime = businessStartTime.add(const Duration(minutes: 30));
      oneDaySeparateThirtyMinuteList.add(businessStartTime);
    }
    oneDaySeparateThirtyMinuteList.removeLast();

    for (int i = 0; i < oneDaySeparateThirtyMinuteList.length; i++) {
      final idFormat = DateFormat('yyyyMMddhhmm');

      await FirebaseFirestore.instance
          .collection('rests')
          .doc(idFormat.format(oneDaySeparateThirtyMinuteList[i]))
          .delete();
    }
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

  ///まだ予約されていない枠を明確にする
  bool isNotAlreadyReserved(DateTime date) {
    final startTime = date;
    final endTime = startTime.add(const Duration(minutes: 1));

    //現時点より前に開始時間が来ている場合false
    if (startTime.isBefore(today)) {
      return false;
    }
    //下記４点、どれか一つでも当てはまればfalse
    //①開始時間より前に終了時間が来ていない
    //②開始時間と終了時間が同時
    //③終了時間より前に開始する
    //④終了時間と開始時間が同時
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

  ///restTimeListに要素を追加・削除している
  ///タップするたびに叩くメソッド
  void onCellTap(DateTime thirtyMinute) {
    final idFormat = DateFormat('yyyyMMddhhmm');

    ///追加・削除するRest情報の定義
    final startTime = thirtyMinute;
    final endTime = thirtyMinute.add(const Duration(minutes: 30));
    final rest = Rest(Timestamp.fromDate(startTime),
        Timestamp.fromDate(endTime), idFormat.format(thirtyMinute));

    for (final registeredRest in alreadyRegisteredRestList) {
      if (registeredRest.startTime.toDate().isAtSameMomentAs(startTime)) {
        for (final willRemoveRegisteredRest in willRemoveRegisteredRestList) {
          if (willRemoveRegisteredRest.startTime
              .toDate()
              .isAtSameMomentAs(startTime)) {
            willRemoveRegisteredRestList.remove(willRemoveRegisteredRest);
            return notifyListeners();
          }
        }
        willRemoveRegisteredRestList.add(rest);
        return notifyListeners();
      }
    }

    for (final willAddRegisteredRest in willAddRegisteredRestList) {
      if (willAddRegisteredRest.startTime
          .toDate()
          .isAtSameMomentAs(startTime)) {
        willAddRegisteredRestList.remove(willAddRegisteredRest);
        return notifyListeners();
      }
    }
    willAddRegisteredRestList.add(rest);
    return notifyListeners();
  }

  ///表示を制御している
  String cellLabel(DateTime thirtyMinute) {
    if (!isNotAlreadyReserved(thirtyMinute)) {
      return '予';
    }
    Rest? addRest;
    Rest? removeRest;
    Rest? registeredRest;

    for (final restTime in willAddRegisteredRestList) {
      if (restTime.startTime.toDate().isAtSameMomentAs(thirtyMinute)) {
        addRest = restTime;
      }
    }

    for (final restTime in willRemoveRegisteredRestList) {
      if (restTime.startTime.toDate().isAtSameMomentAs(thirtyMinute)) {
        removeRest = restTime;
      }
    }

    for (final registered in alreadyRegisteredRestList) {
      if (registered.startTime.toDate().isAtSameMomentAs(thirtyMinute)) {
        registeredRest = registered;
      }
    }

    ///ここに時間として登録されているかどうかが鍵
    ///removeされるものは◯に変わる
    if (registeredRest != null && removeRest == null) {
      return '❌';
    } else if (addRest != null) {
      return '✖︎';
    } else {
      return '○';
    }
  }

  ///Registerモデル
  Future<void> registerRestOwnerTime(BuildContext context) async {
    if (willAddRegisteredRestList.isEmpty &&
        willRemoveRegisteredRestList.isEmpty) {
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
    } else {
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
                  await registerRestTime(context);
                  willRemoveRegisteredRestList.clear();
                  willAddRegisteredRestList.clear();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MasterSelectPage()),
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
    ///あとで、registeredRestListの要素が減っていなければっていう制御も必要
    if (willAddRegisteredRestList.isEmpty &&
        willRemoveRegisteredRestList.isEmpty) {
      return true;
    }
    return await showDialog(
        context: context,
        builder: (dialogContext) {
          return CupertinoAlertDialog(
            title: const Text('登録を中止しますか？'),
            content: const Text('登録した内容は破棄されます'),
            actions: [
              CupertinoButton(
                  child: const Text('いいえ'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  }),
              CupertinoButton(
                child: const Text('OK'),
                onPressed: () {
                  ///restTImeListを初期値に戻す
                  willAddRegisteredRestList.clear();
                  willRemoveRegisteredRestList.clear();

                  Navigator.of(dialogContext).pop(false);
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
  }

  ///Firestoreに情報を送るためのメソッド
  Future<void> registerRestTime(BuildContext context) async {
    for (int i = 0; i < willAddRegisteredRestList.length; i++) {
      await FirebaseFirestore.instance
          .collection('rests')
          .doc(willAddRegisteredRestList[i].restId)
          .set({
        'startTime': willAddRegisteredRestList[i].startTime,
        'endTime': willAddRegisteredRestList[i].endTime,
        'restId': willAddRegisteredRestList[i].restId
      });
    }

    for (int i = 0; i < willRemoveRegisteredRestList.length; i++) {
      await FirebaseFirestore.instance
          .collection('rests')
          .doc(willRemoveRegisteredRestList[i].restId)
          .delete();
    }
  }
}
