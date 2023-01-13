import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/domain/menu.dart';
import 'package:salon_vishu/select_reservation_date/select_reservation_date_page.dart';

import '../common_widget/vishu_app_bar.dart';

import '../domain/reservation.dart';
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
                  children: const [
                    Text('現在、予約情報がありません', style: TextStyle(fontSize: 17)),
                    Text('メニューより予約してみましょう', style: TextStyle(fontSize: 17)),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectReservationDatePage(
                                    menu: Menu(
                                        targetMember: reservation.targetMember,
                                        treatmentDetailList:
                                            reservation.treatmentDetailList,
                                        treatmentDetail:
                                            reservation.treatmentDetail,
                                        beforePrice: reservation.beforePrice,
                                        afterPrice: reservation.afterPrice,
                                        menuIntroduction:
                                            reservation.menuIntroduction,
                                        menuImageUrl: reservation.menuImageUrl,
                                        menuId: reservation.menuId,
                                        treatmentTime:
                                            reservation.treatmentTime))));
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 15),
                              ),
                              const SizedBox(height: 7),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  model.targetCard(reservation),
                                  SizedBox(
                                    width: width * 0.09,
                                  ),
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
                                                    color: HexColor('#989593'),
                                                    border: Border.all(
                                                      color:
                                                          HexColor('#989593'),
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
                                        border:
                                            Border.all(color: Colors.black87),
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                reservation.menuImageUrl))),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 233,
                                        child: Text(
                                          reservation.treatmentDetail,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          if (reservation.beforePrice != null)
                                            Text(
                                              '${reservation.beforePrice}円',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          const Text('▷'),
                                          Text('${reservation.afterPrice}円'),
                                          const SizedBox(width: 40),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: width * 0.3),
                                          Text(
                                              '施術時間： ${reservation.treatmentTime}分',
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
                    ),
                  );
                },
              ),
      );
    });
  }
}
