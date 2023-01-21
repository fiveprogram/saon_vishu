import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/master/push_notification/push_notification_model.dart';

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

    return Consumer<PushNotificationModel>(builder: (context, model, child) {
      return Scaffold(
          appBar: vishuAppBar(appBarTitle: 'プッシュ通知管理', isJapanese: true),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: width),
              SizedBox(
                height: height * 0.2,
                width: width * 0.7,
                child: TextFormField(
                  maxLength: 300,
                  maxLines: 4,
                  controller: model.notificationController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
              SizedBox(
                width: width * 0.6,
                child: ElevatedButton(
                  child: Text('送信する'),
                  onPressed: () {},
                ),
              )
            ],
          ));
    });
  }
}
