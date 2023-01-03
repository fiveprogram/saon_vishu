import 'package:flutter/material.dart';
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

    return ChangeNotifierProvider(
      create: (_) => SelectReservationDateModel(menu),
      child: Scaffold(
        appBar: vishuAppBar(appBarTitle: 'reservation'),
        body: Consumer<SelectReservationDateModel>(
          builder: (context, model, child) {
            final double height = MediaQuery.of(context).size.height;
            final double width = MediaQuery.of(context).size.width;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.03),
                  Row(
                    children: [
                      SizedBox(width: width * 0.03),
                      const Text('予約内容',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: width * 0.03),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            model.targetCard(),
                            SizedBox(height: height * 0.007),
                            Container(
                              height: height * 0.12,
                              width: width * 0.27,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black87),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(menu.menuImageUrl))),
                            ),
                            SizedBox(height: height * 0.01),
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: width * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: model.contentsOfHairList(),
                            ),
                            SizedBox(
                                height: height * 0.11,
                                width: width * 0.6,
                                child: Text(menu.treatmentDetail)),
                            Row(
                              children: [
                                SizedBox(width: width * 0.3),
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
                  SizedBox(height: height * 0.02),
                  Container(
                    height: height * 0.06,
                    width: width,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        color: Colors.white),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('予約日時を選ぶ',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  CalenderWidget(menu: widget.menu),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

///1月9日以降
