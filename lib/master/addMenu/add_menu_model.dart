import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:salon_vishu/domain/menu.dart';

class AddMenuModel extends ChangeNotifier {
  List<Menu> menuList = [];

  //fetchMenuList
  Future<void> fetchMenuList() async {
    Stream<QuerySnapshot> menuStream = FirebaseFirestore.instance
        .collection('menu')
        .orderBy('priority', descending: false)
        .orderBy('afterPrice', descending: false)
        .snapshots();

    menuStream.listen((snapshot) {
      menuList = snapshot.docs.map((DocumentSnapshot doc) {
        return Menu.fromFireStore(doc);
      }).toList();

      notifyListeners();
    });
  }
}
