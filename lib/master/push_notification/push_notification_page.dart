import 'package:firebase_auth/firebase_auth.dart';
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
    return Consumer<PushNotificationModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: vishuAppBar(appBarTitle: 'push notification'),
        body: Center(
          child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text('ログアウト')),
        ),
      );
    });
  }
}
