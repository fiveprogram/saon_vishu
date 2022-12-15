import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class MenuModel extends ChangeNotifier {
  List<Menu> menuList = [];

  //fetchMenuList
  Future<void> fetchMenuList() async {
    User? user = FirebaseAuth.instance.currentUser;
    Stream<QuerySnapshot> menuStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('menu')
        .snapshots();

    menuStream.listen((snapshot) {
      menuList = snapshot.docs.map((DocumentSnapshot doc) {
        return Menu.fromFireStore(doc);
      }).toList();
    });
  }
}
