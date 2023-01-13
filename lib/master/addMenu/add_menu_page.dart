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
        if (model.menuList.isEmpty) {
          return const CircularProgressIndicator();
        }

        //カット内容のリスト
        List<Widget> contentsOfHairList(Menu menu) {
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
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              )
              .toList();
        }

        //対象者を表す
        Widget targetCard(Menu menu) {
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
            width: 50,
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
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          );
        }

        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;

        return Scaffold(
          appBar: vishuAppBar(appBarTitle: 'メニューリスト', isJapanese: true),
          body: Column(
            children: [
              const Text('お好みの条件を１つ選択してください',
                  style: TextStyle(
                      fontSize: 17,
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
                        label: Text(model.treatmentTypeList[index]),
                        selected: model.treatmentListIndex == index,
                        onSelected: (bool value) {
                          if (value) {
                            setState(() {
                              model.filteringMenuList(index);
                            });
                          } else {
                            setState(() {
                              model.deletingFilteringMenuList(
                                  model.treatmentTypeList[index]);
                            });
                          }
                        },
                      ),
                    ).toList()),
              ),
              const Divider(),
              Text(
                  '全${model.filteredMenuList.isEmpty ? model.menuList.length : model.filteredMenuList.length}件',
                  style: const TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold)),
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.filteredMenuList.isEmpty
                        ? model.menuList.length
                        : model.filteredMenuList.length,
                    itemBuilder: (context, index) {
                      if (model.menuList.isEmpty) {
                        return const CircularProgressIndicator();
                      }
                      Menu menu = model.menuList[index];

                      if (model.filteredMenuList.isNotEmpty) {
                        menu = model.filteredMenuList[index];
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
                              padding: const EdgeInsets.all(13.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      targetCard(menu),
                                      SizedBox(
                                        width: width * 0.09,
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Wrap(
                                            children: contentsOfHairList(menu),
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
                                        height: height * 0.09,
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
                                            width: 233,
                                            child: Text(
                                              menu.treatmentDetail,
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
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
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                      const Text('▷'),
                                                      Text(
                                                          '${menu.afterPrice}円'),
                                                      const SizedBox(width: 10),
                                                    ],
                                                  ),
                                                  Text(
                                                      '施術時間：${menu.treatmentTime}分',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                              const SizedBox(width: 30),
                                              IconButton(
                                                  onPressed: () {
                                                    model.menuDelete(
                                                        menu, context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete))
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
