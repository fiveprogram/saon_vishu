import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salon_vishu/sign_in/sign_in_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vishu',
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: HexColor("#3d3d3d"),
          colorSchemeSeed: HexColor("#3d3d3d")),
      home: const SignInPage(),
    );
  }
}
