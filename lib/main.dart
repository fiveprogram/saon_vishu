import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/cancel_reservation/cancel_reservation_model.dart';
import 'package:salon_vishu/main_select_page.dart';
import 'package:salon_vishu/master/addMenu/add_menu_model.dart';
import 'package:salon_vishu/master/booker_calendar/booker_calendar_model.dart';
import 'package:salon_vishu/master/booker_detail/booker_detail_model.dart';
import 'package:salon_vishu/master/master_select_page.dart';
import 'package:salon_vishu/master/push_notification/push_notification_model.dart';
import 'package:salon_vishu/master/rest_date_register/rest_date_register_model.dart';
import 'package:salon_vishu/profile/cancel_guide/cancel_guide_model.dart';
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

/// 通知インスタンスの生成
final FlutterLocalNotificationsPlugin localPlugin =
    FlutterLocalNotificationsPlugin();

///バックグラウンドでメッセージを受け取った時のイベントを定義（メイン関数で発火）
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  localPlugin.initialize(const InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
      android: AndroidInitializationSettings('@mipmap/ic_launcher')));

  if (notification == null) {
    return;
  }

  /// NotificationDetails クラスを使用して、通知チャンネルの詳細を設定します。ここで通知チャンネルのID、
  /// 名前、説明、重要度、優先度、サウンドなどを指定。
  localPlugin.show(
      notification.hashCode,
      "${notification.title}",
      notification.body,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
            presentSound: true, presentAlert: true, presentBadge: true),
        android: AndroidNotificationDetails('channel_id', 'channel_name',
            playSound: true),
      ),
      payload: '1000');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  ///バックグラウンドでの通知
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  ///フォアグラウンドでの通知
  await firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String tokenId = "";

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    // アプリ初期化時に画面にtokenを表示
    firebaseMessaging.getToken().then((String? token) {
      setState(() {
        tokenId = token!;
      });
    });

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //フォアグラウンドでメッセージを受け取った時のイベント
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      localPlugin.initialize(const InitializationSettings(
          iOS: initializationSettingsIOS,
          android: AndroidInitializationSettings('@mipmap/ic_launcher')));
      if (notification == null) {
        return;
      }

      AndroidNotification? android = message.notification?.android;

      if (android != null) {
        localPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              iOS: const DarwinNotificationDetails(
                presentBadge: true,
                presentAlert: true,
                presentSound: true,
              ),
              android: AndroidNotificationDetails('channel.id', 'channel.name',
                  icon: android.smallIcon, playSound: true),
            ));
      }
    });
  }

  ///強制アップデート機能
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
      if (usingVersionIntList[i] > minAvailableVersionIntList[i]) {
        return;
      }
    }

    if (mounted) {
      return showDialog(
        barrierDismissible: false,
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInModel()..fetchProfile()),
        ChangeNotifierProvider(create: (_) => SignUpModel()..fetchVersion()),
        ChangeNotifierProvider(create: (_) => MenuModel()..fetchMenuList()),
        ChangeNotifierProvider(
            create: (_) => ProfileModel()
              ..fetchProfile()
              ..fetchVersion()),
        ChangeNotifierProvider(
            create: (_) => CalendarModel()
              ..getHolidayList()
              ..fetchProfile()
              ..fetchReservationList()
              ..fetchRestList()),
        ChangeNotifierProvider(
            create: (_) => HistoryModel()..fetchReservationList()),
        ChangeNotifierProvider(create: (_) => FinishReservationModel()),
        ChangeNotifierProvider(
            create: (_) => ScheduleModel()
              ..getHolidayList()
              ..fetchRestList()
              ..fetchReservationList()),
        ChangeNotifierProvider(
          create: (_) => RestDateRegisterModel()
            ..getHolidayList()
            ..fetchReservationList()
            ..fetchRestList(),
        ),
        ChangeNotifierProvider(
            create: (_) => BookerCalendarModel()..fetchReservation()),
        ChangeNotifierProvider(
            create: (_) => PushNotificationModel()..fetchDeviceIds()),
        ChangeNotifierProvider(create: (_) => AddMenuModel()..fetchMenuList()),
        ChangeNotifierProvider(create: (_) => CancelReservationModel()),
        ChangeNotifierProvider(
            create: (_) => SalonInfoModel()
              ..fetchInfo()
              ..fetchVersion()),
        ChangeNotifierProvider(create: (_) => BookerDetailModel()),
        ChangeNotifierProvider(create: (_) => CancelGuideModel()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ja', 'JP')],
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
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
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
                  if (snapshot.data!.uid == 'pQKtcv6IqHVA4heqhYb2idBExXO2' ||
                      snapshot.data!.uid == 'WifOh89TR6bCHrBVqmT0IOuSiqf2' ||
                      snapshot.data!.uid == 'LLDpe0jHvdar5gOTtAEthOHVqVA2') {
                    return const MasterSelectPage();
                  }
                  return const MainSelectPage();
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
