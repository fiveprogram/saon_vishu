import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/main_select_page.dart';
import 'package:salon_vishu/master/addMenu/add_menu_model.dart';
import 'package:salon_vishu/master/booker/booker_model.dart';
import 'package:salon_vishu/master/master_select_page.dart';
import 'package:salon_vishu/master/push_notification/push_notification_model.dart';
import 'package:salon_vishu/master/rest_date_register/rest_date_register_model.dart';
import 'package:salon_vishu/master/rest_edit/rest_edit_model.dart';
import 'package:salon_vishu/profile/profile_model.dart';
import 'package:salon_vishu/sign_in/sign_in_model.dart';
import 'package:salon_vishu/sign_in/sign_in_page.dart';
import 'package:salon_vishu/sign_up/sign_up_model.dart';

import 'common_widget/calendar_model.dart';
import 'finish_reservation/finish_reservation_model.dart';
import 'history/history_model.dart';
import 'manager/firebase_option/firebase_options.dart';
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
        ChangeNotifierProvider(create: (_) => RestEditModel()..fetchRestList()),
        ChangeNotifierProvider(
            create: (_) => BookerModel()..fetchReservationList()),
        ChangeNotifierProvider(create: (_) => PushNotificationModel()),
        ChangeNotifierProvider(create: (_) => AddMenuModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'salon "Vishu"',
        theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: HexColor("#c9c5c3"),
            colorSchemeSeed: HexColor("#c9c5c3")),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              ///GoogleAccountでログインした時のみ
              if (snapshot.data!.uid == 'pQKtcv6IqHVA4heqhYb2idBExXO2') {
                return const MasterSelectPage();
              }
              return const MainSelectPage();
            }
            return const SignInPage();
          },
        ),
      ),
    );
  }
}
