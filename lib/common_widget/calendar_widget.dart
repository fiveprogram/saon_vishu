import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../domain/business_hours.dart';
import '../domain/reservation.dart';
import '../domain/rest.dart';
import '../select_reservation_date/select_reservation_date_model.dart';

class CalenderWidget extends StatefulWidget {
  const CalenderWidget({Key? key}) : super(key: key);

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<SelectReservationDateModel>(
      builder: (context, model, child) {
        return Column(
          children: [
            Container(
              height: height * 0.05,
              width: width,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(color: Colors.black26)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      previousWeek = previousWeek + 1;
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black26,
                    ),
                  ),
                  Text('${weekDates(currentDisplayDate())[6].month}月'),
                  IconButton(
                      onPressed: () {
                        previousWeek = previousWeek - 1;
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                      ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26)),
                      height: height * 0.04,
                      width: width * 0.157,
                    ),
                    ...separateThirtyMinutes(currentDisplayDate()).map(
                      (thirtyMinute) => Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black26)),
                        height: height * 0.04,
                        width: width * 0.157,
                        child: Text(
                          '${formatter.format(thirtyMinute)}~',
                        ),
                      ),
                    )
                  ],
                ),
                ...weekDates(currentDisplayDate()).map(
                  (DateTime weekDate) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: weekDate.year == today.year &&
                                    weekDate.month == today.month &&
                                    weekDate.day == today.day
                                ? Colors.white70
                                : Colors.white,
                            border: Border.all(color: Colors.black26)),
                        alignment: Alignment.center,
                        height: height * 0.04,
                        width: width * 0.12,
                        child: Text('${weekDate.day}日'),
                      ),
                      //既に予約されてしまっているか
                      //施術時間と営業時間が競合していないかどうか
                      //施術時間と休憩時間が競合していないかどうか
                      ...separateThirtyMinutes(weekDate).map(
                        (thirtyMinute) {
                          final isAvailableResult = isAvailable(thirtyMinute);
                          return GestureDetector(
                            onTap: () {
                              print(thirtyMinute);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: isAvailableResult
                                      ? Colors.white
                                      : Colors.white70,
                                  border: Border.all(color: Colors.black26)),
                              height: height * 0.04,
                              width: width * 0.12,
                              child: Text(
                                isAvailableResult ? '◯' : '✖︎',
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}

const businessHours = BusinessHours(9, 00, 18, 00);
final formatter = DateFormat('HH:mm');

final today = DateTime.now();

//何週間前の情報を表示しているかを管理
int previousWeek = 0;

DateTime currentDisplayDate() => today.add(Duration(days: -7 * previousWeek));

//与えられた日付を始業時間から営業時間まで30分区切りのリストにするメソッド
List<DateTime> separateThirtyMinutes(DateTime date) {
  //始業時間
  var businessStartTime = DateTime(date.year, date.month, date.day,
      businessHours.openTimeHour, businessHours.openTimeMinute);
  //終業時間
  final businessEndTime = DateTime(date.year, date.month, date.day,
      businessHours.closeTimeHour, businessHours.closeTimeMinute);

  final result = <DateTime>[businessStartTime];
  while (businessStartTime != businessEndTime) {
    businessStartTime = businessStartTime.add(const Duration(minutes: 30));
    result.add(businessStartTime);
  }
  result.removeLast();
  return result;
}

//与えられた日付を含む月曜日から始まる一週間のリスト
List<DateTime> weekDates(DateTime date) {
  //月->日に応じて、0->7の値を取得
  final weekDay = date.weekday;
  final monday = -weekDay;
  final result = <DateTime>[];
  for (var i = monday; i < monday + 7; i++) {
    result.add(date.add(Duration(days: i)));
  }
  return result;
}

//既に予約されてxxしまっているか
//営業時間かどうか
//施術時間と終業時間が競合していないかどうか
bool isAvailable(DateTime date) {
  final startTime = date;
  final endTime = startTime.add(const Duration(minutes: 30));

  print(endTime);
  //現在時刻より前は予約できない。
  if (startTime.isBefore(today)) {
    return false;
  }
  //営業終了時間
  final closeTime = DateTime(startTime.year, startTime.month, startTime.day,
      businessHours.closeTimeHour, businessHours.closeTimeMinute);

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
    if (!(endTime.isBefore(reservation.startTime) ||
        endTime.isAtSameMomentAs(reservation.startTime) ||
        startTime.isAfter(reservation.finishTime) ||
        startTime.isAtSameMomentAs(reservation.finishTime))) {
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

final reservationList = [
  Reservation(
    DateTime(2022, 12, 27, 11, 00),
    DateTime(2022, 12, 27, 12, 00),
    'cut',
    'user01',
  ),
  Reservation(
    DateTime(2022, 12, 23, 10, 30),
    DateTime(2022, 12, 23, 11, 00),
    'cut',
    'user01',
  ),
];

final restList = [
  //12月21日、12:00から12:30まで休み
  Rest(
    DateTime(2022, 12, 28, 12, 00),
    DateTime(2022, 12, 28, 14, 00),
  ),
  Rest(
    DateTime(2022, 12, 31, 9, 00),
    DateTime(2022, 12, 31, 12, 30),
  ),
];
