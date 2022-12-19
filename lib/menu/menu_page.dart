import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/menu_card.dart';
import 'package:salon_vishu/menu/menu_model.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuModel>(builder: (context, model, child) {
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(
              double.infinity,
              56.0,
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: AppBar(
                  actions: [
                    IconButton(
                        onPressed: () {
                          model.popUpFeeList(context);
                        },
                        icon: const Icon(Icons.monetization_on))
                  ],
                  automaticallyImplyLeading: false,
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  backgroundColor: HexColor("#7e796e"),
                  title: const Text('Menu',
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Dancing_Script',
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)),
                  elevation: 10.0,
                ),
              ),
            ),
          ),
          body: ListView.builder(
              shrinkWrap: true,
              itemCount: model.menuList.length,
              itemBuilder: (context, index) {
                return MenuCard(menuIndex: index);
              }));
    });
  }
}
