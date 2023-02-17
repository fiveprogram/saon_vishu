import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/reservation.dart';
import 'package:salon_vishu/master/booker_detail/booker_detail_model.dart';

// ignore: must_be_immutable
class BookerDetailPage extends StatefulWidget {
  Reservation? reservation;
  BookerDetailPage({required this.reservation, Key? key}) : super(key: key);

  @override
  State<BookerDetailPage> createState() => _BookerDetailPageState();
}

class _BookerDetailPageState extends State<BookerDetailPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (widget.reservation == null) {
      return const Center(child: CircularProgressIndicator());
    }
    Reservation reservation = widget.reservation!;

    return Scaffold(
      backgroundColor: HexColor('#fcf8f6'),
      appBar: vishuAppBar(appBarTitle: '予約者情報', isJapanese: true),
      body: Consumer<BookerDetailModel>(builder: (context, model, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.02),
              CircleAvatar(
                maxRadius: 60,
                backgroundImage: NetworkImage(
                  reservation.userImage ??
                      'https://thumb.ac-illust.com/ac/ac500a4028ead506a866103700776220_t.jpeg',
                ),
              ),
              SizedBox(height: height * 0.03),
              Container(
                alignment: Alignment.center,
                height: height * 0.05,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black26),
                        top: BorderSide(color: Colors.black26))),
                child: const Text('予約者情報',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    contentText('名前'),
                    const Expanded(child: SizedBox()),
                    profileText(width, reservation.name),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    contentText('電話番号'),
                    const Expanded(child: SizedBox()),
                    profileText(width, reservation.telephoneNumber),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    contentText('生年月日'),
                    const Expanded(child: SizedBox()),
                    profileText(width, reservation.dateOfBirth),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    contentText('性別'),
                    const Expanded(child: SizedBox()),
                    profileText(width, reservation.gender),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                alignment: Alignment.center,
                height: height * 0.05,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black26),
                        top: BorderSide(color: Colors.black26))),
                child: const Text('施術内容',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Colors.black87,
                  ),
                ),
                surfaceTintColor: Colors.white,
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
                                children: reservation.treatmentDetailList
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
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
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
                                    image: NetworkImage(
                                        reservation.menuImageUrl))),
                          ),
                          SizedBox(width: width * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width * 0.62,
                                child: Text(
                                  reservation.treatmentDetail,
                                  style: TextStyle(fontSize: height * 0.016),
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
                                          decoration:
                                              TextDecoration.lineThrough),
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
                                  Text('施術時間： ${reservation.treatmentTime}分',
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
              SizedBox(height: height * 0.03),
              SizedBox(
                width: width * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      backgroundColor: Colors.black26),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '戻る',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
            ],
          ),
        );
      }),
    );
  }
}

Container profileText(double width, String text) {
  return Container(
    width: width * 0.6,
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black54)),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 22,
      ),
    ),
  );
}

Text contentText(String content) {
  return Text(
    content,
    style: const TextStyle(
      color: Colors.black87,
      fontSize: 22,
    ),
  );
}
