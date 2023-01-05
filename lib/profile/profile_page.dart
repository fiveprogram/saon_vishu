import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/profile/profile_model.dart';

import '../common_widget/vishu_app_bar.dart';
import '../domain/profile.dart';
import '../edit/edit_page.dart';
import '../guide/guid_reservation_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'my page'),
      body: Consumer<ProfileModel>(
        builder: (context, model, child) {
          if (model.profile == null) {
            return const CircularProgressIndicator();
          }

          Profile profile = model.profile!;

          return Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: const [
                  SizedBox(width: 20),
                  Text('・お客様情報',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 60,
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
              const SizedBox(height: 30),
              Row(
                children: const [
                  SizedBox(width: 20),
                  Text('・お客様向けガイド',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              myPageListTile(
                  pageWidget: const GuideReservationPage(),
                  tileName: 'ご予約までの流れ'),
              myPageListTile(
                tileName: '利用規約・ガイドライン',
                pageWidget: const GuideReservationPage(),
              ),
              myPageListTile(
                tileName: 'よくある質問',
                pageWidget: const GuideReservationPage(),
              ),
              Container(
                height: 60,
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12))),
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
              const SizedBox(height: 90),
              const Text('salon Vishu',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontFamily: 'Dancing_Script')),
              const Text(
                'バージョン　1.00.0',
                style: TextStyle(),
              ),
            ],
          );
        },
      ),
    );
  }

  Container myPageListTile(
      {required String tileName, required Widget pageWidget}) {
    return Container(
      height: 60,
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
}
