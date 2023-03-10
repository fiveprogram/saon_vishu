import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/master/addMenu/add_menu_model.dart';
import 'package:salon_vishu/master/add_detail_menu/add_detail_page.dart';

import '../../domain/menu.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({Key? key}) : super(key: key);

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddMenuModel>(
      builder: (context, model, child) {
        if (model.allMenuList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        //カット内容のリスト
        List<Widget> contentsOfHairList(Menu menu, double height) {
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
                      style: TextStyle(
                          fontSize: height * 0.016,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
              .toList();
        }

        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;

        return Scaffold(
          appBar: vishuAppBar(appBarTitle: 'メニューリスト', isJapanese: true),
          body: Column(
            children: [
              Text('お好みの条件を１つ選択してください',
                  style: TextStyle(
                      fontSize: height * 0.02,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                    spacing: 5.0,
                    children: List.generate(
                      model.treatmentTypeList.length,
                      (index) => ChoiceChip(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        label: Text(model.treatmentTypeList[index],
                            style: TextStyle(fontSize: height * 0.017)),
                        selected: model.treatmentListIndex == index,
                        onSelected: (bool value) {
                          if (value) {
                            setState(() {
                              model.filteringMenuList(index);
                            });
                          } else {
                            setState(() {
                              model.deletingFilteringMenuList();
                            });
                          }
                        },
                      ),
                    ).toList()),
              ),
              const Divider(),
              Text(
                  '全${model.filteredDefaultMenuList.isEmpty && model.filteredCouponMenuList.isEmpty ? model.allMenuList.length : model.filteredCouponMenuList.isEmpty ? model.filteredDefaultMenuList.length : model.filteredCouponMenuList.length}件',
                  style: TextStyle(
                      fontSize: height * 0.017,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)),
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.filteredDefaultMenuList.isEmpty &&
                            model.filteredCouponMenuList.isEmpty
                        ? model.allMenuList.length
                        : model.filteredCouponMenuList.isEmpty
                            ? model.filteredDefaultMenuList.length
                            : model.filteredCouponMenuList.length,
                    itemBuilder: (context, index) {
                      if (model.allMenuList.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      Menu menu = model.allMenuList[index];

                      if (model.filteredDefaultMenuList.isNotEmpty &&
                          model.filteredCouponMenuList.isEmpty) {
                        menu = model.filteredDefaultMenuList[index];
                      } else if (model.filteredDefaultMenuList.isEmpty &&
                          model.filteredCouponMenuList.isNotEmpty) {
                        menu = model.filteredCouponMenuList[index];
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) =>
                                      AddDetailPage(menu: menu)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Card(
                            surfaceTintColor: Colors.white,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Wrap(
                                            children: contentsOfHairList(
                                                menu, height),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: height * 0.11,
                                        width: width * 0.19,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black87),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: menu.menuImageUrl != ''
                                                    ? NetworkImage(
                                                        menu.menuImageUrl!)
                                                    : const NetworkImage(
                                                        'https://thumb.photo-ac.com/21/212fac1588475d1867023125f1a52133_t.jpeg'))),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width * 0.62,
                                            child: Text(menu.treatmentDetail,
                                                style: TextStyle(
                                                    fontSize: height * 0.016,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      if (menu.beforePrice !=
                                                          null)
                                                        Text(
                                                          '${menu.beforePrice}円',
                                                          style: TextStyle(
                                                              fontSize: height *
                                                                  0.016,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                      const Text('▷'),
                                                      Text(
                                                          '${menu.afterPrice}円〜',
                                                          style: TextStyle(
                                                              fontSize: height *
                                                                  0.016)),
                                                      SizedBox(
                                                          width: width * 0.01),
                                                    ],
                                                  ),
                                                  Text(
                                                      '施術時間：${menu.treatmentTime}分',
                                                      style: TextStyle(
                                                          fontSize:
                                                              height * 0.017,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                              SizedBox(width: width * 0.02),
                                              ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white70,
                                                    backgroundColor:
                                                        Colors.black26),
                                                onPressed: () {
                                                  model.menuDelete(
                                                      menu, context);
                                                },
                                                icon: const Icon(Icons.delete),
                                                label: const Text(
                                                  '削除',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AddDetailPage()));
              },
              child: const Icon(Icons.add)),
        );
      },
    );
  }
}
