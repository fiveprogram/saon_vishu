import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/master/push_notification/push_notification_model.dart';
import 'package:salon_vishu/master/push_notification/serch_user/serch_user_page.dart';

import '../../domain/profile.dart';

class PushNotificationPage extends StatefulWidget {
  const PushNotificationPage({Key? key}) : super(key: key);

  @override
  State<PushNotificationPage> createState() => _PushNotificationPageState();
}

class _PushNotificationPageState extends State<PushNotificationPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Profile? profile;

    return Consumer<PushNotificationModel>(builder: (context, model, child) {
      return Scaffold(
          backgroundColor: HexColor('#fcf8f6'),
          appBar: vishuAppBar(appBarTitle: 'プッシュ通知管理', isJapanese: true),
          body: Stack(
            children: [
              Focus(
                focusNode: model.focusNode,
                child: GestureDetector(
                  onTap: model.focusNode.requestFocus,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: width * 0.15, height: height * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: width * 0.1, height: height * 0.04),
                            const Text('対象者',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: TextFormField(
                            readOnly: true,
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) =>
                                              const SearchUserPage()))
                                  .then((value) {
                                if (value == null) {
                                  return;
                                }
                                profile = value;
                                model.targetController.text = profile!.name;
                              });
                            },
                            controller: model.targetController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    model.targetController.clear();
                                  },
                                  icon: const Icon(Icons.clear)),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.15, height: height * 0.05),
                        Row(
                          children: [
                            SizedBox(width: width * 0.1, height: height * 0.04),
                            const Text('プッシュ通知タイトル',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: TextFormField(
                            maxLines: 2,
                            controller: model.notificationTitleController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.07, width: width),
                        Row(
                          children: [
                            SizedBox(width: width * 0.1, height: height * 0.04),
                            const Text('お知らせ内容',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: TextFormField(
                            maxLength: 300,
                            maxLines: 4,
                            controller: model.notificationContentController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        SizedBox(
                          height: height * 0.05,
                          width: width * 0.6,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black26,
                            ),
                            child: Text(
                              '送信する',
                              style: TextStyle(
                                fontSize: height * 0.025,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              if (model.targetController.text == '') {
                                model.sendPushNotification(context);
                              }
                              if (model.targetController.text != '' &&
                                  profile != null) {
                                model.sendSpecificPushNotification(
                                    context, profile!);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (model.isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ));
    });
  }
}
