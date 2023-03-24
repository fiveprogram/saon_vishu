import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/reservation.dart';

class BookerDetailModel extends ChangeNotifier {
  final historyDateFormatter = DateFormat('yyyy年M月d日 H時mm分~');

  Future<void> deleteReservation(BuildContext context,
      {required Reservation reservation}) async {
    await showDialog(
        context: context,
        builder: (dialogContext) {
          return CupertinoAlertDialog(
            title: const Text('予約を削除しますか？'),
            actions: [
              CupertinoButton(
                  child: const Text('戻る'),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  }),
              CupertinoButton(
                  child: const Text('削除する'),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(reservation.uid)
                        .collection('reservation')
                        .doc(reservation.reservationId)
                        .delete();
                    print(reservation.uid);
                    print(reservation.reservationId);

                    Navigator.pop(dialogContext);

                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
