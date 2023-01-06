import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class RestDateRegisterModel extends ChangeNotifier {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  DateTime? startTime;
  DateTime? endTime;

  DateFormat restDateFormat = DateFormat('M月d日(E)', 'ja');
  bool isAllDay = false;

  Future<void> getDate(BuildContext context) async {
    await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(const Duration(days: 365)),
        onChanged: (date) {
      null;
    }, onConfirm: (date) {
      startTime = date;
      startDateController.text =
          '${date.month}月${date.day}日(${dayOfWeek(date.weekday)})';
      notifyListeners();
    },
        currentTime:
            startDateController.text.isEmpty ? DateTime.now() : startTime,
        locale: LocaleType.jp);
  }

  String dayOfWeek(int weekday) {
    switch (weekday) {
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
      case 7:
        return '日';
      default:
        return '月';
    }
  }

  Future<void> registerRestTime() async {
    if (startDateController.text == '' && endDateController.text == '') {
      await FirebaseFirestore.instance.collection('rests').add({});
    }
  }
}
