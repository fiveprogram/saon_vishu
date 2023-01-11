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
    Profile profile = widget.profile;

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: '予約完了', isJapanese: true),
      body: Consumer<FinishReservationModel>(
        builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('ご予約ありがとうございます😄',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 15)),
                        const SizedBox(height: 7),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            model.targetCard(menu),
                            SizedBox(
                              width: width * 0.09,
                            ),
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
                                              color: HexColor('#989593'),
                                              border: Border.all(
                                                color: HexColor('#989593'),
                                              ),
                                            ),
                                            child: Text(
                                              treatmentDetail,
                                              style: const TextStyle(
                                                  fontSize: 12,
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
                              height: height * 0.09,
                              width: width * 0.19,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black87),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(menu.menuImageUrl))),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 233,
                                  child: Text(
                                    menu.treatmentDetail,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(menu.afterPrice),
                                Row(
                                  children: [
                                    SizedBox(width: width * 0.3),
                                    Text('施術時間： ${menu.treatmentTime}分',
                                        style: const TextStyle(
                                            fontSize: 15,
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
                const SizedBox(height: 40),
                const Text('お客様のメールアドレスへ、確認メールを送付しました。',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                const SizedBox(height: 3),
                const Text(
                    '*しばらく経ってもメールが届かない場合は、ご登録頂いたメールアドレスが間違っているか、迷惑メールフォルダに振り分けられている可能性がございます。',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainSelectPage()));
                    },
                    child: const Text('メインページに戻る'))
              ],
            ),
          );
        },
      ),
    );
  }
}
