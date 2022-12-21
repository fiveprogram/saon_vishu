import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/menu/menu_model.dart';
import 'package:salon_vishu/select_reservation_date/select_reservation_date_page.dart';

import '../domain/menu.dart';

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
    return Consumer<MenuModel>(builder: (context, model, child) {
      Menu menu = model.menuList[widget.menuIndex];
      if (model.filteredMenuList.isNotEmpty) {
        menu = model.filteredMenuList[widget.menuIndex];
      }

      //カット内容のリスト
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

      return Padding(
        padding: const EdgeInsets.all(12.0),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      targetCard(),
                      const SizedBox(
                        width: 40,
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
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(menu.menuImageUrl))),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 233,
                            child: Text(
                              menu.treatmentDetail,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                              Text(menu.afterPrice),
                              const SizedBox(width: 40),
                              SizedBox(
                                  height: 40,
                                  width: 70,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor('#dfd9cd'),
                                          foregroundColor: Colors.black54),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectReservationDatePage(
                                                        menu: menu)));
                                      },
                                      child: const Text('予約')))
                            ],
                          )
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
    });
  }
}
