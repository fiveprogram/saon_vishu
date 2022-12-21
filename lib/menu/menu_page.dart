import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/menu_card.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/menu/menu_model.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: vishuAppBar(appBarTitle: 'Menu'),
          body: Consumer<MenuModel>(
            builder: (context, model, child) {
              return Column(
                children: [
                  const Text('お好みの条件を１つ選択してください',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 5.0,
                      children: model.treatmentTypeList.map((contents) {
                        return FilterChip(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          label: Text(contents),
                          selected: model.filteredTreatmentTypeList
                              .contains(contents),
                          onSelected: (bool value) {
                            setState(() {
                              if (value) {
                                if (!model.filteredTreatmentTypeList
                                    .contains(contents)) {
                                  model.filteredTreatmentTypeList.add(contents);
                                  model.filteringMenuList();
                                }
                              } else {
                                String? deleteContent;
                                model.filteredTreatmentTypeList
                                    .removeWhere((String name) {
                                  deleteContent = name;
                                  return name == contents;
                                });
                                model.deletingFilteringMenuList(deleteContent!);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
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
                          return MenuCard(menuIndex: index);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
