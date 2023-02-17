import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../common_widget/vishu_app_bar.dart';
import '../domain/menu.dart';
import '../domain/profile.dart';
import '../main_select_page.dart';
import 'finish_reservation_model.dart';

// ignore: must_be_immutable
class FinishReservationPage extends StatefulWidget {
  Menu menu;
  DateTime startTime;
  Profile profile;
  FinishReservationPage(
      {required this.profile,
      required this.menu,
      required this.startTime,
      Key? key})
      : super(key: key);

  @override
  State<FinishReservationPage> createState() => _FinishReservationPageState();
}

class _FinishReservationPageState extends State<FinishReservationPage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    Menu menu = widget.menu;
    DateTime startTime = widget.startTime;

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: '予約完了', isJapanese: true),
      body: Consumer<FinishReservationModel>(
        builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text('ご予約ありがとうございます😄',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: height * 0.022)),
                const SizedBox(height: 20),
                Card(
                  surfaceTintColor: Colors.white,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${model.visitStoreFormatter.format(startTime)}のご来店',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: height * 0.018)),
                        SizedBox(height: height * 0.01),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  children: widget.menu.treatmentDetailList
                                      .map(
                                        (treatmentDetail) => Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                              color: HexColor('#7a3425'),
                                              border: Border.all(
                                                color: HexColor('#7a3425'),
                                              ),
                                            ),
                                            child: Text(
                                              treatmentDetail,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.11,
                              width: width * 0.19,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black87),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(menu.menuImageUrl!))),
                            ),
                            SizedBox(width: width * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width * 0.62,
                                  child: Text(
                                    menu.treatmentDetail,
                                    style: TextStyle(fontSize: height * 0.016),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  '${menu.afterPrice}円〜',
                                  style: TextStyle(
                                    fontSize: height * 0.016,
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: width * 0.3),
                                    Text('施術時間： ${menu.treatmentTime}分',
                                        style: TextStyle(
                                            fontSize: height * 0.016,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.04),
                Text('お客様へ確認のプッシュ通知を送信させていただきました。',
                    style: TextStyle(
                        fontSize: height * 0.017, color: Colors.black)),
                SizedBox(height: height * 0.01),
                Text('*しばらく経っても通知が届かない場合は、アプリの通知設定をご確認ください。',
                    style: TextStyle(
                      fontSize: height * 0.016,
                      color: Colors.black54,
                    )),
                SizedBox(height: height * 0.05),
                SizedBox(
                  width: width * 0.5,
                  height: height * 0.05,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainSelectPage()));
                      },
                      child: Text(
                        'メインページに戻る',
                        style: TextStyle(
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
