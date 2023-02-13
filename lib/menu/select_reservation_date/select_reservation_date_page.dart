import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/domain/menu.dart';
import 'package:salon_vishu/menu/select_reservation_date/select_reservation_date_model.dart';

import '../../common_widget/calendar_widget.dart';
import '../../common_widget/vishu_app_bar.dart';

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
        appBar: vishuAppBar(appBarTitle: '予約日時', isJapanese: true),
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
                      Text('予約内容',
                          style: TextStyle(
                              fontSize: height * 0.02,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: width * 0.03),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            model.targetCard(height, width),
                            SizedBox(height: height * 0.007),
                            Container(
                              height: height * 0.12,
                              width: width * 0.22,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black87),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(menu.menuImageUrl!))),
                            ),
                            SizedBox(height: height * 0.01),
                            //料金の横並び
                            Row(
                              children: [
                                if (menu.beforePrice != null)
                                  Text(
                                    '${menu.beforePrice}円',
                                    style: TextStyle(
                                        fontSize: height * 0.017,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                const Text('▷'),
                                Text(
                                  '${menu.afterPrice}円〜',
                                  style: TextStyle(
                                      fontSize: height * 0.017,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: width * 0.02),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: model.contentsOfHairList(height),
                              ),
                              SizedBox(
                                  height: height * 0.11,
                                  width: width * 0.6,
                                  child: Text(
                                    menu.treatmentDetail,
                                    style: TextStyle(fontSize: height * 0.017),
                                  )),
                              Row(
                                children: [
                                  SizedBox(width: width * 0.25),
                                  Text('施術時間：${menu.treatmentTime}分',
                                      style: TextStyle(
                                          fontSize: height * 0.017,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Text('【メニュー紹介♪】', style: TextStyle(fontSize: height * 0.018)),
                  Text(menu.menuIntroduction,
                      style: TextStyle(fontSize: height * 0.016)),
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
                  CalenderWidget(menu: menu),
                  SizedBox(height: height * 0.03),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          model.directCallVishu(context);
                        },
                        child: Text(
                          'オーナーと直接連絡を取る',
                          style: TextStyle(
                            fontSize: height * 0.018,
                          ),
                        )),
                  ),
                  SizedBox(height: height * 0.1),
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
