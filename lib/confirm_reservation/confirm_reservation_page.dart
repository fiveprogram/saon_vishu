import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/confirm_reservation/confirm_reservation_model.dart';
import 'package:salon_vishu/domain/menu.dart';

import '../domain/profile.dart';

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

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height * 0.24,
                      decoration: BoxDecoration(
                          color: HexColor('#fcf8f6'),
                          border: const Border(
                              top: BorderSide(color: Colors.black38),
                              bottom: BorderSide(color: Colors.black38))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                          image:
                                              NetworkImage(menu.menuImageUrl))),
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
                                              decoration:
                                                  TextDecoration.lineThrough),
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
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: width * 0.3,
                            decoration: BoxDecoration(
                              color: HexColor('#fcf8f6'),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'お支払い',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black54),
                                ),
                                SizedBox(height: height * 0.14),
                                const Text(
                                  'お支払い時期',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black54),
                                ),
                                SizedBox(height: height * 0.03),
                                const Text(
                                  'キャンセル時の連絡方法',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#fcf8f6'),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'クレジットカード',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87),
                                  ),
                                  const Text(
                                    'Mastercard / Visa / JCB \nAmerican Express / Diners Club',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  const Text(
                                    'その他決済',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87),
                                  ),
                                  const Text(
                                    'PayPay / LINE Pay',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  const Text(
                                    '来店時支払い',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black87),
                                  ),
                                  SizedBox(height: height * 0.03),
                                  const Text(
                                    'キャンセル連絡はメッセージ機能をご連絡ください。',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          style: TextStyle(fontSize: 18)),
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
                      child: ElevatedButton(
                        onPressed: () {
                          model.registerReservationDate(
                              context: context,
                              reservationDate:
                                  '${startTime.year}年${startTime.month}月${startTime.day}日 (${model.dayOfWeekFormatter.format(startTime)}) ${model.startMinuteFormatter.format(startTime)}',
                              sendFirestore: sendFirebaseWithReservationDate);
                          Future.delayed(const Duration(seconds: 3));
                        },
                        child: const Text(
                          '予約する',
                          style: TextStyle(color: Colors.black87),
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
