import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/menu.dart';
import 'package:salon_vishu/select_reservation_date/select_reservation_date_model.dart';

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
                const SizedBox(height: 20),
                Row(
                  children: const [
                    SizedBox(width: 20),
                    Text('予約内容',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          targetCard(),
                          const SizedBox(height: 5),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(menu.menuImageUrl))),
                          ),
                          const SizedBox(height: 10),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: contentsOfHairList(),
                          ),
                          SizedBox(
                              width: 233, child: Text(menu.treatmentDetail)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const Text('予約日時を選ぶ',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  height: deviceHeight / 15,
                  width: deviceWidth,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: ListTile(
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                    title: Center(
                      child: Text(
                        '${model.calendar.month}月',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: deviceHeight / 15,
                      width: deviceWidth / 8,
                      decoration: BoxDecoration(border: Border.all()),
                    ),
                    Row(
                      children: model.dateColumn(
                          height: deviceHeight, width: deviceWidth),
                    ),
                  ],
                ),
                Column(
                  children:
                      model.timeList(height: deviceHeight, width: deviceWidth),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

///1月9日以降
