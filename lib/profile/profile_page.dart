import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/profile/cancel_guide/cancel_guide_page.dart';
import 'package:salon_vishu/profile/profile_model.dart';
import 'package:salon_vishu/profile/salon_info/salon_info_page.dart';

import '../common_widget/vishu_app_bar.dart';
import '../domain/profile.dart';
import '../domain/version.dart';
import 'edit/edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Container myPageListTile(
        {required String tileName, required Widget pageWidget}) {
      return Container(
        height: height * 0.072,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black26))),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => pageWidget));
          },
          tileColor: HexColor('#fcf8f6'),
          title: Text(tileName,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black54,
              )),
          trailing: const Icon(Icons.keyboard_arrow_right, size: 30),
        ),
      );
    }

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'Home'),
      body: Consumer<ProfileModel>(
        builder: (context, model, child) {
          if (model.profile == null) {
            return const CircularProgressIndicator();
          }

          if (model.version == null) {
            return const CircularProgressIndicator();
          }
          Version version = model.version!;

          Profile profile = model.profile!;

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.01),
                Row(
                  children: [
                    SizedBox(width: width * 0.02),
                    const Text('・お客様情報',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Container(
                  height: height * 0.075,
                  decoration: BoxDecoration(
                      border: Border.all(color: HexColor('#989593'))),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPage(
                                    profile: profile,
                                  )));
                    },
                    tileColor: HexColor('#fcf8f6'),
                    leading: CircleAvatar(
                      radius: 25,
                      foregroundColor: Colors.black54,
                      backgroundColor: HexColor('#fcf8f6'),
                      backgroundImage: profile.imgUrl != ''
                          ? NetworkImage(profile.imgUrl)
                          : const NetworkImage(
                              'https://everydayicons.jp/wp/wp-content/themes/everydayicons/icons/png/ei-person.png'),
                    ),
                    title: Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right, size: 30),
                  ),
                ),
                SizedBox(height: height * 0.04),
                Row(
                  children: [
                    SizedBox(width: width * 0.02),
                    const Text('・お客様向けガイド',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: height * 0.02),
                myPageListTile(
                    pageWidget: const CancelGuidePage(),
                    tileName: 'キャンセル方法について'),
                myPageListTile(
                  tileName: 'オーナー&サロン紹介',
                  pageWidget: const SalonInfoPage(),
                ),
                Container(
                  height: height * 0.072,
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black26))),
                  child: ListTile(
                    onTap: () {
                      model.urlTermOfService();
                    },
                    tileColor: HexColor('#fcf8f6'),
                    title: const Text('利用規約',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        )),
                    trailing: const Icon(Icons.keyboard_arrow_right, size: 30),
                  ),
                ),
                Container(
                  height: height * 0.072,
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black26))),
                  child: ListTile(
                    onTap: () {
                      model.policyUrl();
                    },
                    tileColor: HexColor('#fcf8f6'),
                    title: const Text('プライバシーポリシー',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        )),
                    trailing: const Icon(Icons.keyboard_arrow_right, size: 30),
                  ),
                ),
                Container(
                  height: height * 0.075,
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black26))),
                  child: ListTile(
                    onTap: () {
                      model.signOut(context);
                    },
                    tileColor: HexColor('#fcf8f6'),
                    title: const Text('ログアウト',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        )),
                    trailing: const Icon(Icons.keyboard_arrow_right, size: 30),
                  ),
                ),
                SizedBox(height: height * 0.03),
                const Text('salon Vishu',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontFamily: 'Dancing_Script')),
                if (Platform.isIOS)
                  Text(
                    'version　${version.iosMinAvailableVersion}',
                    style: const TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                if (Platform.isAndroid)
                  Text(
                    'version　${version.androidMinAvailableVersion}',
                    style: const TextStyle(fontSize: 20, color: Colors.black54),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
