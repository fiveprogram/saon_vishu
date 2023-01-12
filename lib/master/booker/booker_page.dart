import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/reservation.dart';
import 'package:salon_vishu/master/booker/booker_model.dart';
import 'package:salon_vishu/master/detail_profile/detail_profile_page.dart';

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
                itemCount: model.reservationList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Reservation reservation = model.reservationList[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailProfilePage(uid: reservation.uid)));
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
            ],
          ),
        ),
      );
    });
  }
}
