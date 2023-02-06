import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_vishu/domain/reservation.dart';
import 'package:salon_vishu/main_select_page.dart';

class CancelReservationModel extends ChangeNotifier {
  DateFormat dayOfWeekFormatter = DateFormat('EE', 'ja_JP');
  DateFormat startMinuteFormatter = DateFormat('HH:mm');
  DateTime nowTime = DateTime.now();

  ///loading
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    return notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    return notifyListeners();
  }

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> cancelDialog(
      BuildContext context, Reservation reservation, DateTime date) async {
    if (date.month == nowTime.month &&
        date.day == nowTime.day &&
        nowTime.isBefore(date)) {
      await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              '当日キャンセルのため、お電話にてお問い合わせ下さい。',
              style: TextStyle(fontSize: 20),
            ),
            content: const Text(
              '0721-21-8824',
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              CupertinoButton(
                  child: const Text('戻る'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('キャンセルしますか？'),
            content: Column(
              children: const [
                SizedBox(height: 5),
                Text(
                    '以下に該当する予約キャンセルは、サロンスタッフへの迷惑行為としてみなし、ご利用を制限させていただく場合がございますのでご注意ください。'),
                SizedBox(height: 5),
                Text(
                  '・頻繁にキャンセルを繰り返す',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              CupertinoButton(
                  child: const Text('いいえ'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                child: const Text('はい'),
                onPressed: () async {
                  startLoading();
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .collection('reservations')
                      .doc(reservation.reservationId)
                      .delete();

                  Future.delayed(const Duration(minutes: 2));
                  endLoading();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainSelectPage()),
                      (route) => false);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
