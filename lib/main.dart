import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/add_page.dart';
import 'package:salon_vishu/menu/menu_page.dart';
import 'package:salon_vishu/sign_in/sign_in_model.dart';
import 'package:salon_vishu/sign_in/sign_in_page.dart';
import 'package:salon_vishu/sign_up/sign_up_model.dart';

import 'firebase_option/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInModel()),
        ChangeNotifierProvider(create: (_) => SignUpModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'salon "Vishu"',
        theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: HexColor("#bdc9c5"),
            colorSchemeSeed: HexColor("#bdc9c5")),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return const MenuPage();
              }
              return const AddPage();
            }),
      ),
    );
  }
}
