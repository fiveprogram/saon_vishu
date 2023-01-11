import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/reservation.dart';
import 'package:salon_vishu/master/booker/booker_model.dart';

import '../../domain/menu.dart';

class BookerPage extends StatefulWidget {
  const BookerPage({Key? key}) : super(key: key);

  @override
  State<BookerPage> createState() => _BookerPageState();
}

class _BookerPageState extends State<BookerPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<BookerModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: vishuAppBar(appBarTitle: '予約者一覧', isJapanese: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                itemCount: model.bookerList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Menu menu = model.bookerList[index];
                  Reservation reservation = model.reservationList[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      surfaceTintColor: Colors.white,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${model.historyDateFormatter.format(reservation.startTime.toDate())}のご利用',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 15),
                            ),
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
                                      children: menu.treatmentDetailList
                                          .map(
                                            (treatmentDetail) => Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2),
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
                                          image:
                                              NetworkImage(menu.menuImageUrl))),
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
                                    Row(
                                      children: [
                                        if (menu.beforePrice != '')
                                          Text(
                                            menu.beforePrice!,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        const Text('▷'),
                                        Text(menu.afterPrice),
                                        const SizedBox(width: 40),
                                      ],
                                    ),
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
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
