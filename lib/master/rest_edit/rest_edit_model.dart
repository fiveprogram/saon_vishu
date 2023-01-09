import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../domain/rest.dart';

class RestEditModel extends ChangeNotifier {
  List<Rest> restTimeList = [];

  Future<void> fetchRestList() async {
    Stream<QuerySnapshot> restStream =
        FirebaseFirestore.instance.collectionGroup('rests').snapshots();

    restStream.listen(
      (snapshot) {
        restTimeList = snapshot.docs
            .map((DocumentSnapshot doc) => Rest.fromFirestore(doc))
            .toList();

        ///データベースにある情報を全てRestTimeListに放り込んでいる

        notifyListeners();
      },
    );
  }
}
