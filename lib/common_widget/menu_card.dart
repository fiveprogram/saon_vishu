import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../domain/menu.dart';
import '../menu/menu_model.dart';
import '../menu/select_reservation_date/select_reservation_date_page.dart';

// ignore: must_be_immutable
class MenuCard extends StatefulWidget {
  int menuIndex;
  MenuCard({required this.menuIndex, super.key});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<MenuModel>(builder: (context, model, child) {
      if (model.menuList.isEmpty) {
        return const CircularProgressIndicator();
      }
      Menu menu = model.menuList[widget.menuIndex];

      if (model.filteredMenuList.isNotEmpty) {
        menu = model.filteredMenuList[widget.menuIndex];
      }

      //カット内容のリスト
      List<Widget> contentsOfHairList() {
        return menu.treatmentDetailList
            .map(
              (treatmentDetail) => Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: HexColor('#989593'),
                    border: Border.all(
                      color: HexColor('#989593'),
                    ),
                  ),
                  child: Text(
                    treatmentDetail,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
            .toList();
      }

      //対象者を表す
      Widget targetCard() {
        HexColor targetColor(String targetMember) {
          switch (targetMember) {
            case '新規':
              return HexColor('#344eba');
            case '再来':
              return HexColor('#7a3425');
            case '全員':
              return HexColor('#e28e7a');
            default:
              return HexColor('#e28e7a');
          }
        }

        return Container(
          width: width * 0.12,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            color: targetColor(menu.targetMember),
            border: Border.all(
              color: targetColor(menu.targetMember),
            ),
          ),
          child: Center(
            child: Text(
              menu.targetMember,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      targetCard(),
                      SizedBox(
                        width: width * 0.09,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            children: contentsOfHairList(),
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
                        width: width * 0.20,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black87),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(menu.menuImageUrl!))),
                      ),
                      SizedBox(width: width * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width * 0.62,
                            child: Text(
                              menu.treatmentDetail,
                              style: TextStyle(fontSize: height * 0.016),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (menu.beforePrice != null)
                                        Text(
                                          '${menu.beforePrice}円',
                                          style: TextStyle(
                                              fontSize: height * 0.016,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      const Text('▷'),
                                      Text(
                                        '${menu.afterPrice}円〜',
                                        style: TextStyle(
                                          fontSize: height * 0.016,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.03),
                                    ],
                                  ),
                                  Text('施術時間：${menu.treatmentTime}分',
                                      style: TextStyle(
                                          fontSize: height * 0.016,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(width: width * 0.04),
                              SizedBox(
                                width: width * 0.2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black26,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectReservationDatePage(
                                                    menu: menu)));
                                  },
                                  child: const Text(
                                    '予約',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

//
