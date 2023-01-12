import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/profile.dart';
import 'package:salon_vishu/master/detail_profile/detail_profile_model.dart';

// ignore: must_be_immutable
class DetailProfilePage extends StatefulWidget {
  String uid;
  DetailProfilePage({required this.uid, Key? key}) : super(key: key);

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => DetailProfileModel(widget.uid)..fetchProfile(),
      child: Consumer<DetailProfileModel>(builder: (context, model, child) {
        if (model.profile == null) {
          return const CircularProgressIndicator();
        }
        Profile profile = model.profile!;
        return Scaffold(
          appBar: vishuAppBar(appBarTitle: '予約者情報', isJapanese: true),
          body: SizedBox(
            height: height,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                    radius: 64,
                    backgroundImage: profile.imgUrl != ''
                        ? NetworkImage(profile.imgUrl)
                        : const NetworkImage(
                            'https://jobneta.sasamedia.net/miyashikai/wp-content/uploads/2017/02/default-avatar.png')),
                const SizedBox(height: 15),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      contentText('名前'),
                      const Expanded(child: SizedBox()),
                      profileText(width, profile.name),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      contentText('メール'),
                      const Expanded(child: SizedBox()),
                      profileText(width, profile.email),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      contentText('電話番号'),
                      const Expanded(child: SizedBox()),
                      profileText(width, profile.telephoneNumber),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      contentText('生年月日'),
                      const Expanded(child: SizedBox()),
                      profileText(width, profile.dateOfBirth),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: width * 0.4,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('戻る')),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Container profileText(double width, String text) {
    return Container(
      width: width * 0.6,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black54)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 22,
        ),
      ),
    );
  }

  Text contentText(String content) {
    return Text(
      content,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 22,
      ),
    );
  }
}
