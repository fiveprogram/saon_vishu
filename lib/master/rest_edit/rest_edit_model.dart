import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_vishu/master/master_select_page.dart';

import '../../domain/rest.dart';

class RestEditModel extends ChangeNotifier {
  List<Rest> restTimeList = [];
  List<Rest> deleteRestList = [];

  DateFormat restFormatter = DateFormat('yyyy/M/d 　h時mm分~');

  Future<void> addDeleteList(Rest rest) async {
    if (deleteRestList.isEmpty) {
      deleteRestList.add(rest);
    } else if (deleteRestList.contains(rest)) {
      deleteRestList.remove(rest);
    } else {
      deleteRestList.add(rest);
    }
  }

  Future<void> deleteRegister(BuildContext context) async {
    if (deleteRestList.isEmpty) {
      await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('入力がありません'),
              actions: [
                CupertinoButton(
                  child: const Text('戻る'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    } else {
      await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('削除してもよろしいですか？'),
              actions: [
                CupertinoButton(
                  child: const Text('いいえ'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoButton(
                  child: const Text('削除'),
                  onPressed: () async {
                    for (int i = 0; i < deleteRestList.length; i++) {
                      await FirebaseFirestore.instance
                          .collection('rests')
                          .doc(deleteRestList[i].restId)
                          .delete();

                      Future.delayed(const Duration(minutes: 1));

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MasterSelectPage()),
                          (route) => false);
                    }
                  },
                ),
              ],
            );
          });
    }
  }

  Future<void> fetchRestList() async {
    final today = DateTime.now();
    Stream<QuerySnapshot> restStream =
        FirebaseFirestore.instance.collectionGroup('rests').snapshots();

    restStream.listen(
      (snapshot) {
        restTimeList = snapshot.docs
            .map((DocumentSnapshot doc) => Rest.fromFirestore(doc))
            .toList();
        notifyListeners();
      },
    );

    for (int i = 0; i < restTimeList.length; i++) {
      if (restTimeList[i].startTime.toDate().isBefore(today)) {
        await FirebaseFirestore.instance
            .collection('rests')
            .doc(restTimeList[i].restId)
            .delete();
      }
    }
  }
}
