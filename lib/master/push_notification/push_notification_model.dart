import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:salon_vishu/domain/device_token_id.dart';

import '../../domain/profile.dart';

class PushNotificationModel extends ChangeNotifier {
  final notificationTitleController = TextEditingController();
  final notificationContentController = TextEditingController();
  final targetController = TextEditingController();
  final focusNode = FocusNode();

  List<DeviceTokenId> deviceTokenIdList = [];

  Future<void> fetchDeviceIds() async {
    final deviceIdStream =
        FirebaseFirestore.instance.collectionGroup('deviceTokenId').snapshots();

    deviceIdStream.listen((snapshot) {
      deviceTokenIdList = snapshot.docs.map((DocumentSnapshot doc) {
        return DeviceTokenId.fromFirestore(doc);
      }).toList();
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
                    endLoading();
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
                    targetController.clear();
                    notificationTitleController.clear();
                    notificationContentController.clear();
                    endLoading();
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  Future<void> sendSpecificPushNotification(
      BuildContext context, Profile profile) async {
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
    } else if (targetController.text != '' ||
        notificationContentController.text != '' ||
        notificationTitleController.text != '') {
      await showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('本当に送信してもよろしいですか？'),
              actions: [
                CupertinoButton(
                    child: const Text('戻る'),
                    onPressed: () {
                      endLoading();
                      Navigator.pop(context);
                    }),
                CupertinoButton(
                    child: const Text('送信'),
                    onPressed: () async {
                      final deviceGot = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(profile.uid)
                          .collection('deviceTokenId')
                          .get();

                      final filterDevices = deviceGot.docs
                          .map((e) => DeviceTokenId.fromFirestore(e))
                          .toList();

                      notifyListeners();
                      final deviceIds =
                          filterDevices.map((e) => e.deviceId).toSet().toList();

                      await FirebaseFirestore.instance
                          .collection('pushNotification')
                          .add({
                        'person': targetController.text,
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
                              builder: (dialogContext) {
                                return CupertinoAlertDialog(
                                  title: const Text('送信が完了しました。'),
                                  actions: [
                                    CupertinoButton(
                                        child: const Text('戻る'),
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        }),
                                  ],
                                );
                              });
                        },
                      );
                      targetController.clear();
                      notificationTitleController.clear();
                      notificationContentController.clear();
                      endLoading();
                      Navigator.pop(context);
                    }),
              ],
            );
          });
    }
  }
}
