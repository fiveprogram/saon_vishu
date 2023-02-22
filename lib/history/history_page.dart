import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/cancel_reservation/cancel_reservation_page.dart';
import 'package:salon_vishu/domain/menu.dart';

import '../common_widget/vishu_app_bar.dart';

import '../domain/reservation.dart';
import '../menu/select_reservation_date/select_reservation_date_page.dart';
import 'history_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<HistoryModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: vishuAppBar(appBarTitle: '予約履歴', isJapanese: true),
        body: model.reservationList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('現在、予約情報がありません',
                        style: TextStyle(fontSize: height * 0.02)),
                    Text('メニューより予約してみましょう',
                        style: TextStyle(fontSize: height * 0.02)),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: model.reservationList.length,
                itemBuilder: (context, index) {
                  if (model.reservationList.isEmpty) {
                    return const CircularProgressIndicator();
                  }

                  Reservation reservation = model.reservationList[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: reservation.startTime
                              .toDate()
                              .isBefore(DateTime.now())
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectReservationDatePage(
                                              menu: Menu(
                                                  isCallable: false,
                                                  treatmentDetailList:
                                                      reservation
                                                          .treatmentDetailList,
                                                  treatmentDetail: reservation
                                                      .treatmentDetail,
                                                  beforePrice:
                                                      reservation.beforePrice,
                                                  afterPrice:
                                                      reservation.afterPrice,
                                                  menuIntroduction: reservation
                                                      .menuIntroduction,
                                                  menuImageUrl:
                                                      reservation.menuImageUrl,
                                                  menuId: reservation.menuId,
                                                  treatmentTime:
                                                      reservation.treatmentTime,
                                                  priority:
                                                      reservation.priority,
                                                  isNeedExtraMoney: reservation
                                                      .isNeedExtraMoney))));
                            }
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CancelReservationPage(
                                            reservation: reservation,
                                          )));
                            },
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
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: height * 0.018),
                              ),
                              SizedBox(height: height * 0.01),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Wrap(
                                        children: reservation
                                            .treatmentDetailList
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
                                                    color: HexColor('#7a3425'),
                                                    border: Border.all(
                                                      color:
                                                          HexColor('#7a3425'),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    treatmentDetail,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                        border:
                                            Border.all(color: Colors.black87),
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                reservation.menuImageUrl))),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width * 0.62,
                                        child: Text(
                                          reservation.treatmentDetail,
                                          style: TextStyle(
                                              fontSize: height * 0.016),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Row(
                                        children: [
                                          if (reservation.beforePrice != null)
                                            Text(
                                              '${reservation.beforePrice}円',
                                              style: TextStyle(
                                                  fontSize: height * 0.016,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          const Text('▷'),
                                          Text(
                                            '${reservation.afterPrice}円〜',
                                            style: TextStyle(
                                              fontSize: height * 0.016,
                                            ),
                                          ),
                                          SizedBox(width: width * 0.03),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: width * 0.3),
                                          Text(
                                              '施術時間： ${reservation.treatmentTime}分',
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
                    ),
                  );
                },
              ),
      );
    });
  }
}
