import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/menu.dart';
import 'package:salon_vishu/select_reservation_date/select_reservation_date_model.dart';

import '../common_widget/calendar_widget.dart';

// ignore: must_be_immutable
class SelectReservationDatePage extends StatefulWidget {
  Menu menu;
  SelectReservationDatePage({required this.menu, Key? key}) : super(key: key);

  @override
  State<SelectReservationDatePage> createState() =>
      _SelectReservationDatePageState();
}

class _SelectReservationDatePageState extends State<SelectReservationDatePage> {
  @override
  Widget build(BuildContext context) {
    Menu menu = widget.menu;

    List<Widget> contentsOfHairList() {
      return menu.treatmentDetailList
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: HexColor('#7e796e'),
                  border: Border.all(
                    color: HexColor('#7e796e'),
                  ),
                ),
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          )
          .toList();
    }

    //対象者を表す
    Widget targetCard() {
      return menu.isTargetAllMember
          ? Container(
              width: 50,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                color: HexColor('#e28e7a'),
                border: Border.all(
                  color: HexColor('#e28e7a'),
                ),
              ),
              child: const Center(
                child: Text(
                  '全員',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          : Container(
              width: 50,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                color: HexColor('#7a3425'),
                border: Border.all(
                  color: HexColor('#7a3425'),
                ),
              ),
              child: const Center(
                child: Text(
                  '新規',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            );
    }

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'reservation'),
      body: Consumer<SelectReservationDateModel>(
        builder: (context, model, child) {
          final double deviceHeight = MediaQuery.of(context).size.height;
          final double deviceWidth = MediaQuery.of(context).size.width;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: deviceHeight * 0.03),
                Row(
                  children: [
                    SizedBox(width: deviceWidth * 0.03),
                    const Text('予約内容',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: deviceHeight * 0.02),
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: deviceWidth * 0.03),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          targetCard(),
                          SizedBox(height: deviceHeight * 0.007),
                          Container(
                            height: deviceHeight * 0.1,
                            width: deviceWidth * 0.25,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(menu.menuImageUrl))),
                          ),
                          SizedBox(height: deviceHeight * 0.01),
                          //料金の横並び
                          Row(
                            children: [
                              if (menu.beforePrice != '')
                                Text(
                                  menu.beforePrice,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              const Text('▷'),
                              Text(
                                menu.afterPrice,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(width: deviceWidth * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: contentsOfHairList(),
                          ),
                          SizedBox(
                              height: deviceHeight * 0.11,
                              width: deviceWidth * 0.6,
                              child: Text(menu.treatmentDetail)),
                          Row(
                            children: [
                              SizedBox(width: deviceWidth * 0.3),
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
                ),
                const Divider(),
                const Text('予約日時を選ぶ',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
                const Divider(),
                CalenderWidget(menu: widget.menu),
              ],
            ),
          );
        },
      ),
    );
  }
}

///1月9日以降
