import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

PreferredSize vishuAppBar({required String appBarTitle, isJapanese = false}) {
  return PreferredSize(
    preferredSize: const Size(
      double.infinity,
      56.0,
    ),
    child: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: AppBar(
          // actions: [
          //   IconButton(
          //       onPressed: () async {
          //         await FirebaseAuth.instance.signOut();
          //       },
          //       icon: const Icon(Icons.logout))
          // ],
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: HexColor("#989593"),
          title: Text(appBarTitle,
              style: isJapanese == false
                  ? const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Dancing_Script')
                  : const TextStyle(
                      fontSize: 30,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    )),
          elevation: 10.0,
        ),
      ),
    ),
  );
}
