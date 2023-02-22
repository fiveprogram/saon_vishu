import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
      if (model.allMenuList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      Menu menu = model.allMenuList[widget.menuIndex];

      if (model.filteredDefaultMenuList.isNotEmpty &&
          model.filteredCouponMenuList.isEmpty) {
        menu = model.filteredDefaultMenuList[widget.menuIndex];
      } else if (model.filteredDefaultMenuList.isEmpty &&
          model.filteredCouponMenuList.isNotEmpty) {
        menu = model.filteredCouponMenuList[widget.menuIndex];
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
                    color: HexColor('#7a3425'),
                    border: Border.all(
                      color: HexColor('#7a3425'),
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

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: () async {
            menu.isCallable == false
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SelectReservationDatePage(menu: menu)))
                : await showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return CupertinoAlertDialog(
                        title: const Text('このメニューは電話予約のみ予約可能です'),
                        actions: [
                          CupertinoButton(
                              child: const Text('戻る'),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              }),
                          CupertinoButton(
                              child: const Text('電話をかける'),
                              onPressed: () async {
                                final Uri launchUri = Uri(
                                  scheme: 'tel',
                                  path: '0721-21-8824',
                                );

                                await launchUrl(launchUri);
                              })
                        ],
                      );
                    });
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
                                  onPressed: () async {
                                    menu.isCallable == false
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectReservationDatePage(
                                                        menu: menu)))
                                        : await showDialog(
                                            context: context,
                                            builder: (dialogContext) {
                                              return CupertinoAlertDialog(
                                                title: const Text(
                                                    'このメニューは電話予約のみ予約可能です'),
                                                actions: [
                                                  CupertinoButton(
                                                      child: const Text('戻る'),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            dialogContext);
                                                      }),
                                                  CupertinoButton(
                                                      child:
                                                          const Text('電話をかける'),
                                                      onPressed: () async {
                                                        final Uri launchUri =
                                                            Uri(
                                                          scheme: 'tel',
                                                          path: '0721-21-8824',
                                                        );

                                                        await launchUrl(
                                                            launchUri);
                                                      })
                                                ],
                                              );
                                            });
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
