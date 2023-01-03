import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../domain/profile.dart';

class ConfirmReservationModel extends ChangeNotifier {
  Profile profile;
  ConfirmReservationModel({required this.profile}) {
    nameController.text = profile.name;
    telephoneNumberController.text = profile.telephoneNumber;
    emailController.text = profile.email;
    dateOfBirthController.text = profile.dateOfBirth;
  }

  User? user = FirebaseAuth.instance.currentUser;
  String? errorText;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telephoneNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  DateFormat dayOfWeekFormatter = DateFormat('EE', 'ja_JP');
  DateFormat startMinuteFormatter = DateFormat('HH:mm');

  DateTime? registerDateOfBirth;

  Future<void> dateOfBirthPicker(
    BuildContext context,
  ) async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1920, 3, 5),
        maxTime: DateTime.now(), onChanged: (date) {
      null;
    }, onConfirm: (date) {
      dateOfBirthController.text = '${date.year}年${date.month}月${date.day}日';
      registerDateOfBirth = date;
      notifyListeners();
    },
        currentTime: dateOfBirthController.text.isEmpty
            ? DateTime.now()
            : registerDateOfBirth,
        locale: LocaleType.jp);
  }

  Future<void> registerReservationDate(
      {required BuildContext context,
      required String reservationDate,
      required AsyncCallback sendFirestore}) async {
    if (nameController.text == '' ||
        emailController.text == '' ||
        telephoneNumberController.text == '' ||
        dateOfBirthController.text == '') {
      showDialog(
        context: context,
        builder: (context) {
          print('a');
          return CupertinoAlertDialog(
            title: const Text('未入力の項目があります'),
            actions: [
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('戻る'),
              )
            ],
          );
        },
      );
    }
    print('b');
    await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('予約を完了しますか？'),
          content: Text(reservationDate),
          actions: [
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('戻る'),
            ),
            CupertinoButton(
              onPressed: sendFirestore,
              child: const Text('完了'),
            )
          ],
        );
      },
    );
  }

  Container guidListTile({
    required double height,
    required double width,
    required double deviceWidth,
    required TextEditingController controller,
    required String hintText,
    Future<void> Function()? picker,
    bool? isNumberOnly,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: HexColor('#fcf8f6'),
          border: Border(bottom: BorderSide(color: HexColor('#7e796e')))),
      child: ListTile(
        tileColor: Colors.white,
        leading: Text(hintText,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black54,
            )),
        title: SizedBox(
          width: width,
          child: Row(
            children: [
              SizedBox(width: deviceWidth),
              Expanded(
                child: TextFormField(
                  onTap: picker,
                  readOnly: picker != null ? true : false,
                  keyboardType:
                      isNumberOnly != null ? TextInputType.number : null,
                  inputFormatters: isNumberOnly != null
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
                  decoration: InputDecoration(
                    hintText: hintText,
                  ),
                  controller: controller,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
