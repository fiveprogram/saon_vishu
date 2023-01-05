import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/select_reservation_date/select_reservation_date_page.dart';

import '../common_widget/vishu_app_bar.dart';
import '../domain/menu.dart';
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

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: '予約履歴', isJapanese: true),
      body: Consumer<HistoryModel>(
        builder: (context, model, child) {
          return FutureBuilder(
              future: model.addHistory(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: model.reservationList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (model.myHistoryList.isEmpty ||
                        model.myHistoryList.isEmpty) {
                      return const CircularProgressIndicator();
                    }
                    Menu menu = model.myHistoryList[index];
                    Reservation reservation = model.reservationList[index];

                    print(model.myHistoryList.length);
                    print(model.reservationList.length);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SelectReservationDatePage(menu: menu)));
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
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  4)),
                                                      color:
                                                          HexColor('#989593'),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  menu.menuImageUrl))),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 233,
                                          child: Text(
                                            menu.treatmentDetail,
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              menu.beforePrice,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  decoration: TextDecoration
                                                      .lineThrough),
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
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                );
              });
        },
      ),
    );
  }
}
