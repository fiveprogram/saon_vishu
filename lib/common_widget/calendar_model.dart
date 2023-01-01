import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:salon_vishu/domain/business_hours.dart';

class CalendarModel extends ChangeNotifier {
  DateTime today = DateTime.now();

  int previousWeeks = -1;
  DateFormat dayOfWeekFormatter = DateFormat('EE', 'ja_JP');

  ///カレンダーを表示する上で、１週間先の日時を取得する。
  ///ページが遷移すれば、previousWeeksの値の変化に伴い、返り値が変わる。
  DateTime currentDisplayDate() {
    return today.add(Duration(days: -7 * previousWeeks));
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
    final weekDay = date.weekday;
    final startDate = -weekDay;
    final result = <DateTime>[];

    for (int i = startDate; i < startDate + 7; i++) {
      result.add(date.add(Duration(days: i)));
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

    ///②の就業時間側
    final closeTime = DateTime(date.year, date.month, date.day,
        businessHour.closeTimeHour, businessHour.closeTimeMinute);

    if (endTime.isAfter(closeTime)) {
      return false;
    }
    return true;
  }
}
