import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectReservationDateModel extends ChangeNotifier {
  DateTime calendar = DateTime.now();

  List<String> timeTextList = [
    '9:00',
    '9:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
  ];

  ///曜日
  String weekdayText(int index) {
    switch ((calendar.weekday + index) % 7) {
      case 1:
        return '月';
      case 2:
        return '火';
      case 3:
        return '水';
      case 4:
        return '木';
      case 5:
        return '金';
      case 6:
        return '土';
      case 0:
        return '日';
      default:
        return '月';
    }
  }

  ///予約カレンダーの日時を表す
  List<Container> dateColumn({required double height, required double width}) {
    return List.generate(
      7,
      (index) {
        print(calendar.weekday + index);
        return Container(
          height: height / 15,
          width: width / 8,
          decoration: BoxDecoration(border: Border.all()),
          child: Text('${calendar.day + index}\n(${weekdayText(index)})',
              textAlign: TextAlign.center),
        );
      },
    );
  }

  ///予約カレンダーの時間区分を表す
  List<Container> timeList({required double height, required double width}) {
    return List.generate(
      timeTextList.length,
      (index) => Container(
        height: height / 15,
        width: width / 8,
        decoration: BoxDecoration(border: Border.all()),
        child: Text(timeTextList[index], textAlign: TextAlign.center),
      ),
    );
  }

  ///予約可能か表示しているセル
  List<Container> bookableCellList(
      {required double height,
      required double width,
      required bool isBookable}) {
    return List.generate(
      timeTextList.length,
      (index) => Container(
        height: height / 15,
        width: width / 8,
        decoration: BoxDecoration(border: Border.all()),
        child: Text(isBookable ? '🔴' : '✖️',
            style: const TextStyle(fontSize: 20, color: Colors.black54),
            textAlign: TextAlign.center),
      ),
    );
  }
}
