import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/confirm_reservation/confirm_reservation_model.dart';
import 'package:salon_vishu/domain/menu.dart';

import '../domain/profile.dart';
import '../finish_reservation_page.dart';

// ignore: must_be_immutable
class ConfirmReservationPage extends StatefulWidget {
  Menu menu;
  DateTime startTime;
  Profile profile;
  ConfirmReservationPage(
      {required this.profile,
      required this.menu,
      required this.startTime,
      Key? key})
      : super(key: key);

  @override
  State<ConfirmReservationPage> createState() => _ConfirmReservationPageState();
}

class _ConfirmReservationPageState extends State<ConfirmReservationPage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    Menu menu = widget.menu;
    DateTime startTime = widget.startTime;
    Profile profile = widget.profile;

    return ChangeNotifierProvider(
      create: (_) => ConfirmReservationModel(profile: profile),
      child: Scaffold(
        backgroundColor: HexColor('#fcf8f6'),
        appBar: vishuAppBar(appBarTitle: 'confirm'),
        body: Consumer<ConfirmReservationModel>(
          builder: (context, model, child) {
            ///予約情報を登録するためのメソッド
            Future<void> sendFirebaseWithReservationDate() async {
              print(5);
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(model.user!.uid)
                  .collection('reservations')
                  .add({
                'startTime': startTime,
                'finishTime':
                    startTime.add(Duration(minutes: menu.treatmentTime)),
                'menuId': menu.menuId,
                'uid': model.user!.uid
              });
            }

            Future<void> registerReservationDate(
                {required BuildContext context,
                required String reservationDate}) async {
              if (model.nameController.text == '' ||
                  model.emailController.text == '' ||
                  model.telephoneNumberController.text == '' ||
                  model.dateOfBirthController.text == '') {
                showDialog(
                  context: context,
                  builder: (context) {
                    print(1);
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
              await showDialog(
                context: context,
                builder: (context) {
                  print(2);
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
                        onPressed: () {
                          print(3);
                          sendFirebaseWithReservationDate();
                          print(4);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FinishReservationPage()),
                              (route) => false);
                        },
                        child: const Text('完了'),
                      )
                    ],
                  );
                },
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: height * 0.12,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black87),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(menu.menuImageUrl))),
                          ),
                        ),
                        SizedBox(width: width * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${startTime.year}年${startTime.month}月${startTime.day}日 (${model.dayOfWeekFormatter.format(startTime)}) ${model.startMinuteFormatter.format(startTime)}',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: height * 0.015),
                            SizedBox(
                              width: width * 0.66,
                              child: Text(
                                menu.treatmentDetail,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black87),
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                            Row(
                              children: [
                                if (menu.beforePrice != '')
                                  Text(
                                    menu.beforePrice,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                const Text('▷'),
                                Text(
                                  menu.afterPrice,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                            Row(
                              children: [
                                SizedBox(width: width * 0.3),
                                Text('施術時間：${menu.treatmentTime}分',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    const Text(
                      '決済方法',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '💳クレジットカード',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87),
                    ),
                    const Text(
                      'Mastercard / Visa / JCB \nAmerican Express / Diners Club',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '💳その他決済',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87),
                    ),
                    const Text(
                      'PayPay / LINE Pay',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: height * 0.03),
                    const Text(
                      '決済時期',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      '来店時支払い',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: height * 0.03),
                    const Text(
                      'キャンセル連絡時',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'キャンセル連絡はメッセージ機能をご連絡ください。',
                      style: TextStyle(fontSize: 17, color: Colors.black87),
                    ),
                    SizedBox(height: height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                          color: HexColor('#fcf8f6'),
                          border: const Border(
                              bottom: BorderSide(color: Colors.black26),
                              top: BorderSide(color: Colors.black26))),
                      child: const Text('お客様個人情報(必須)',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                    ),
                    model.guidListTile(
                        height: height * 0.07,
                        width: width,
                        deviceWidth: width * 0.05,
                        controller: model.nameController,
                        hintText: 'フルネーム'),
                    model.guidListTile(
                        height: height * 0.07,
                        width: width,
                        deviceWidth: width * 0.15,
                        controller: model.emailController,
                        hintText: 'メール'),
                    model.guidListTile(
                        height: height * 0.07,
                        width: width,
                        deviceWidth: width * 0.10,
                        isNumberOnly: true,
                        controller: model.telephoneNumberController,
                        hintText: '電話番号'),
                    model.guidListTile(
                        height: height * 0.07,
                        width: width,
                        deviceWidth: width * 0.15,
                        picker: () async {
                          model.dateOfBirthPicker(context);
                        },
                        controller: model.dateOfBirthController,
                        hintText: '誕生日'),
                    SizedBox(height: height * 0.04),
                    Center(
                      child: SizedBox(
                        width: width * 0.5,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor('#c9c5c3')),
                          onPressed: () {
                            registerReservationDate(
                              context: context,
                              reservationDate:
                                  '${startTime.year}年${startTime.month}月${startTime.day}日 (${model.dayOfWeekFormatter.format(startTime)}) ${model.startMinuteFormatter.format(startTime)}',
                            );
                          },
                          child: const Text(
                            '予約完了',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.07),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
