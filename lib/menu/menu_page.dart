import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common_widget/menu_card.dart';
import '../common_widget/vishu_app_bar.dart';
import 'menu_model.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<MenuModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: vishuAppBar(appBarTitle: 'Menu'),
          body: Column(
            children: [
              Text('お好みの条件を１つ選択してください',
                  style: TextStyle(
                      fontSize: height * 0.02,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: height * 0.01,
              ),
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
                  style: TextStyle(
                      fontSize: height * 0.017,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold)),
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
          ),
        );
      },
    );
  }
}
