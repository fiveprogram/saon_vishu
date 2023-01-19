import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/cancel_reservation/cancel_reservation_model.dart';

import 'package:salon_vishu/master/addMenu/add_menu_model.dart';

import 'package:salon_vishu/master/booker/booker_model.dart';
import 'package:salon_vishu/master/master_select_page.dart';
import 'package:salon_vishu/master/push_notification/push_notification_model.dart';
import 'package:salon_vishu/master/rest_date_register/rest_date_register_model.dart';
import 'package:salon_vishu/profile/profile_model.dart';
import 'package:salon_vishu/profile/salon_info/salon_info_model.dart';
import 'package:salon_vishu/sign_in/sign_in_model.dart';
import 'package:salon_vishu/sign_in/sign_in_page.dart';
import 'package:salon_vishu/sign_up/sign_up_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_widget/calendar_model.dart';
import 'finish_reservation/finish_reservation_model.dart';
import 'firebase_options.dart';
import 'history/history_model.dart';
import 'master/schedule/schedule_model.dart';
import 'menu/menu_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  initializeDateFormatting('ja');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> forceUpdate(
      String iosVersion, String androidVersion, BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    ///２つのバージョンををint型のリストに変換している
    final usingVersion = packageInfo.version;
    final usingVersionStringList = usingVersion.split('.');
    final usingVersionIntList =
        usingVersionStringList.map((e) => int.parse(e)).toList();
    final minAvailableVersion = Platform.isIOS ? iosVersion : androidVersion;
    final minAvailableVersionStringList = minAvailableVersion.split('.');
    final minAvailableVersionIntList =
        minAvailableVersionStringList.map((e) => int.parse(e)).toList();
    for (int i = 0; i < 3; i++) {
      if (usingVersionIntList[i] < minAvailableVersionIntList[i]) {
        return showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('新しいバージョンのアプリが利用可能です。ストアより更新版を入手して、ご利用下さい。'),
            actions: [
              CupertinoButton(
                child: const Text('今すぐ更新'),
                onPressed: () async {
                  if (Platform.isAndroid || Platform.isIOS) {
                    final appId = Platform.isAndroid
                        ? 'com.itsukage.salonVishu'
                        : '1666140616';
                    final url = Uri.parse(
                      Platform.isAndroid
                          ? "https://play.google.com/store/apps/details?id=$appId"
                          : "https://apps.apple.com/app/id$appId",
                    );
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInModel()..fetchProfile()),
        ChangeNotifierProvider(create: (_) => SignUpModel()),
        ChangeNotifierProvider(create: (_) => MenuModel()..fetchMenuList()),
        ChangeNotifierProvider(create: (_) => ProfileModel()..fetchProfile()),
        ChangeNotifierProvider(
            create: (_) => CalendarModel()
              ..fetchProfile()
              ..fetchReservationList()),
        ChangeNotifierProvider(
            create: (_) => HistoryModel()..fetchReservationList()),
        ChangeNotifierProvider(create: (_) => FinishReservationModel()),
        ChangeNotifierProvider(
            create: (_) => ScheduleModel()
              ..fetchRestList()
              ..fetchReservationList()),
        ChangeNotifierProvider(
          create: (_) => RestDateRegisterModel()
            ..fetchReservationList()
            ..fetchRestList(),
        ),
        ChangeNotifierProvider(
            create: (_) => BookerModel()..fetchReservationList()),
        ChangeNotifierProvider(create: (_) => PushNotificationModel()),
        ChangeNotifierProvider(create: (_) => AddMenuModel()..fetchMenuList()),
        ChangeNotifierProvider(create: (_) => CancelReservationModel()),
        ChangeNotifierProvider(create: (_) => SalonInfoModel()..fetchInfo()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'salon "Vishu"',
        theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: HexColor("#c9c5c3"),
            colorSchemeSeed: HexColor("#c9c5c3")),
        home: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('force_update')
              .doc('uHoECUdMBarAX1H61FTC')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.active) {
              final doc = snapshot.data!;
              forceUpdate(doc['iosMinAvailableVersion'],
                  doc['androidMinAvailableVersion'], context);
            }
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  ///GoogleAccountでログインした時のみ
                  if (snapshot.data!.uid == 'pQKtcv6IqHVA4heqhYb2idBExXO2') {
                    return const MasterSelectPage();
                  }
                  return const MasterSelectPage();
                }
                return const SignInPage();
              },
            );
          },
        ),
      ),
    );
  }
}
