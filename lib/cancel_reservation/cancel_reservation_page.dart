import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/cancel_reservation/cancel_reservation_model.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/reservation.dart';

// ignore: must_be_immutable
class CancelReservationPage extends StatefulWidget {
  Reservation reservation;
  CancelReservationPage({required this.reservation, Key? key})
      : super(key: key);

  @override
  State<CancelReservationPage> createState() => _CancelReservationPageState();
}

class _CancelReservationPageState extends State<CancelReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CancelReservationModel>(builder: (context, model, child) {
      final height = MediaQuery.of(context).size.height;
      final width = MediaQuery.of(context).size.width;

      Reservation reservation = widget.reservation;
      final startTime = reservation.startTime.toDate();

      return Stack(
        children: [
          Scaffold(
            backgroundColor: HexColor('#fcf8f6'),
            appBar: vishuAppBar(appBarTitle: '予約確認', isJapanese: true),
            body: SingleChildScrollView(
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
                        Container(
                          height: height * 0.12,
                          width: width * 0.23,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black87),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage(reservation.menuImageUrl))),
                        ),
                        SizedBox(width: width * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${startTime.year}年${startTime.month}月${startTime.day}日 (${model.dayOfWeekFormatter.format(startTime)}) ${model.startMinuteFormatter.format(startTime)}~',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: height * 0.015),
                            SizedBox(
                              width: width * 0.66,
                              child: Text(
                                reservation.treatmentDetail,
                                style: TextStyle(
                                    fontSize: height * 0.016,
                                    color: Colors.black87),
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                            Row(
                              children: [
                                if (reservation.beforePrice != null)
                                  Text(
                                    '${reservation.beforePrice}円',
                                    style: TextStyle(
                                        fontSize: height * 0.016,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                const Text('▷'),
                                Text(
                                  '${reservation.afterPrice}円',
                                  style: TextStyle(
                                      fontSize: height * 0.016,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                            Row(
                              children: [
                                SizedBox(width: width * 0.3),
                                Text('施術時間：${reservation.treatmentTime}分',
                                    style: TextStyle(
                                        fontSize: height * 0.016,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(height: height * 0.04),
                    Text(
                      '決済方法',
                      style: TextStyle(
                          fontSize: height * 0.024,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      '💳クレジットカード',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.018,
                          color: Colors.black87),
                    ),
                    Text(
                      'Mastercard / Visa / JCB \nAmerican Express / Diners Club',
                      style: TextStyle(
                          fontSize: height * 0.016, color: Colors.black87),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      '💳その他決済',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.018,
                          color: Colors.black87),
                    ),
                    Text(
                      'PayPay / LINE Pay',
                      style: TextStyle(
                          fontSize: height * 0.016, color: Colors.black87),
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      '決済時期',
                      style: TextStyle(
                          fontSize: height * 0.024,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '来店時支払い',
                      style: TextStyle(
                          fontSize: height * 0.016, color: Colors.black87),
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      'キャンセル連絡',
                      style: TextStyle(
                          fontSize: height * 0.024,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '前日18時まで→無料\n当日の場合→料金の50%を請求',
                      style: TextStyle(
                          fontSize: height * 0.016, color: Colors.black87),
                    ),
                    SizedBox(height: height * 0.03),
                    const Divider(),
                    SizedBox(height: height * 0.02),
                    Center(
                      child: SizedBox(
                        width: width * 0.5,
                        height: height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#989593"),
                              foregroundColor: Colors.white),
                          onPressed: () {
                            model.cancelDialog(context, reservation,
                                reservation.startTime.toDate());
                          },
                          child: Text('予約をキャンセルする',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.014)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (model.isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      );
    });
  }
}

///ユーザーがもし一度予約したあと、キャンセルをしてしまうと、reservationの情報は全て削除されてしまう。
///そのため、キャンセル理由などが明確に知りたい場合は、別のデータ構造で対応するのがベスト。
///
