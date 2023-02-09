import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:salon_vishu/domain/device_token_id.dart';

import '../domain/profile.dart';

class ConfirmReservationModel extends ChangeNotifier {
  Profile profile;
  ConfirmReservationModel({required this.profile}) {
    nameController.text = profile.name;
    telephoneNumberController.text = profile.telephoneNumber;
    emailController.text = profile.email;
    dateOfBirthController.text = profile.dateOfBirth;
    gender = profile.gender;
    if (profile.lastVisit != null) {
      lastVisit = profile.lastVisit;
    }
    if (profile.imgUrl != '') {
      userImage = profile.imgUrl;
    }
  }

  User? user = FirebaseAuth.instance.currentUser;
  String? errorText;

  Timestamp? lastVisit;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telephoneNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  String? gender;
  String? userImage;

  DateFormat dayOfWeekFormatter = DateFormat('EE', 'ja_JP');
  DateFormat startMinuteFormatter = DateFormat('HH:mm');

  DateTime? registerDateOfBirth;

  bool isLateConfirm = false;
  bool isChildConfirm = false;
  bool isLongHairConfirm = false;

  final focusNode = FocusNode();

  ///isNeedExtraMoney
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
            ? DateTime(1980, 1, 1)
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

  List<DeviceTokenId> deviceTokenIdList = [];

  Future<void> fetchDeviceId() async {
    final deviceIdStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('deviceTokenId')
        .snapshots();

    deviceIdStream.listen((snapshot) {
      deviceTokenIdList = snapshot.docs
          .map((DocumentSnapshot doc) => DeviceTokenId.fromFirestore(doc))
          .toList();
      notifyListeners();
    });
  }

  DateTime now = DateTime.now();

  Future<void> isCheckWithinThirtyMinutes(
      BuildContext context, DateTime startTime) async {
    final checkTime = startTime.add(const Duration(minutes: -30));

    if (checkTime.isBefore(now)) {
      await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('予約時間が迫っているため、直接お電話にてご確認ください。'),
              content: const Text('0721-21-8824'),
              actions: [
                CupertinoButton(
                    child: const Text('戻る'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            );
          });
    }
  }
}
