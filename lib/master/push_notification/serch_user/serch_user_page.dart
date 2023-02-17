import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../common_widget/vishu_app_bar.dart';
import '../../../domain/profile.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({Key? key}) : super(key: key);

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final searchUserController = TextEditingController();

  List<Profile> profileList = [];
  List<Profile> searchUserList = [];
  Future<void> fetchProfile() async {
    final profileStream =
        FirebaseFirestore.instance.collectionGroup('users').snapshots();

    profileStream.listen((snapshot) {
      profileList = snapshot.docs
          .map((DocumentSnapshot doc) => Profile.fromFirestore(doc))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: HexColor('#fcf8f6'),
      appBar: vishuAppBar(appBarTitle: 'ユーザー検索', isJapanese: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: height * 0.02),
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: searchUserController,
                  onFieldSubmitted: (String? userName) {
                    for (final profile in profileList) {
                      if (profile.name == userName) {
                        searchUserList.add(profile);
                      }
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          searchUserController.clear();
                          searchUserList.clear();
                        },
                        icon: const Icon(Icons.clear)),
                    hintText: '検索',
                    icon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const Divider(),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchUserList.isNotEmpty
                    ? searchUserList.length
                    : profileList.length,
                itemBuilder: (context, index) {
                  Profile profile = profileList[index];

                  if (searchUserList.isNotEmpty) {
                    profile = searchUserList[index];
                  }
                  return Container(
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black38))),
                    child: ListTile(
                      title: Text(profile.name),
                      onTap: () {
                        Navigator.of(context).pop(profile);
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
