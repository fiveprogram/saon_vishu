import 'package:firebase_auth/firebase_auth.dart';
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
    gender = profile.gender;
  }

  User? user = FirebaseAuth.instance.currentUser;
  String? errorText;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telephoneNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  String? gender;

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
              fontSize: 16,
              color: Colors.black87,
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
