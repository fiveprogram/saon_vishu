import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/calendar_model.dart';
import 'package:salon_vishu/confirm_reservation/confirm_reservation_model.dart';
import 'package:salon_vishu/main_select_page.dart';
import 'package:salon_vishu/menu/menu_model.dart';
import 'package:salon_vishu/profile/profile_model.dart';
import 'package:salon_vishu/select_reservation_date/select_reservation_date_model.dart';
import 'package:salon_vishu/sign_in/sign_in_model.dart';
import 'package:salon_vishu/sign_in/sign_in_page.dart';
import 'package:salon_vishu/sign_up/sign_up_model.dart';

import 'manager/firebase_option/firebase_options.dart';

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
        ChangeNotifierProvider(create: (_) => SignInModel()),
        ChangeNotifierProvider(create: (_) => SignUpModel()),
        ChangeNotifierProvider(create: (_) => MenuModel()..fetchMenuList()),
        ChangeNotifierProvider(create: (_) => ProfileModel()..fetchProfile()),
        ChangeNotifierProvider(create: (_) => ConfirmReservationModel()),
        ChangeNotifierProvider(
            create: (_) => CalendarModel()..fetchReservationList()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'salon "Vishu"',
        theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: HexColor("#ada89c"),
            colorSchemeSeed: HexColor("#ada89c")),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return const MainSelectPage();
              }
              return const SignInPage();
            }),
      ),
    );
  }
}
