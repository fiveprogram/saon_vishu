import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:salon_vishu/domain/device_token_id.dart';

class PushNotificationModel extends ChangeNotifier {
  final notificationTitleController = TextEditingController();
  final notificationContentController = TextEditingController();

  List<DeviceTokenId> deviceTokenIdList = [];

  Future<void> fetchDeviceIds() async {
    final deviceIdStream =
        FirebaseFirestore.instance.collectionGroup('deviceTokenId').snapshots();

    deviceIdStream.listen((snapshot) {
      deviceTokenIdList = snapshot.docs
          .map((DocumentSnapshot doc) => DeviceTokenId.fromFirestore(doc))
          .toList();
      notifyListeners();
    });
  }

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

  Future<void> sendPushNotification(BuildContext context) async {
    startLoading();
    if (notificationContentController.text == '' ||
        notificationTitleController.text == '') {
      await showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('未入力の項目があります。'),
              actions: [
                CupertinoButton(
                    child: const Text('戻る'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            );
          });
      endLoading();
      return;
    }

    if (deviceTokenIdList.isEmpty) {
      await showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('デバイスIDが指定されていません。'),
              actions: [
                CupertinoButton(
                    child: const Text('戻る'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            );
          });
      endLoading();
      return;
    }

    await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('本当に送信してもよろしいですか？'),
            actions: [
              CupertinoButton(
                  child: const Text('戻る'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                  child: const Text('送信'),
                  onPressed: () async {
                    final deviceIds = deviceTokenIdList
                        .map((e) => e.deviceId)
                        .toSet()
                        .toList();

                    await FirebaseFirestore.instance
                        .collection('pushNotification')
                        .add({
                      'title': notificationTitleController.text,
                      'content': notificationContentController.text,
                      'deviceIdList': deviceIds,
                    }).then(
                      (DocumentReference ref) async {
                        await FirebaseFirestore.instance
                            .collection('pushNotification')
                            .doc(ref.id)
                            .update({'notificationId': ref.id});

                        await showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('送信が完了しました。'),
                                actions: [
                                  CupertinoButton(
                                      child: const Text('戻る'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ],
                              );
                            });
                      },
                    );
                    endLoading();
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
