import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

PreferredSize vishuAppBar({required String appBarTitle}) {
  return PreferredSize(
    preferredSize: const Size(
      double.infinity,
      56.0,
    ),
    child: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: HexColor("#8d9895"),
          title: Text(appBarTitle,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black54)),
          leading: const Icon(Icons.chevron_left),
          elevation: 10.0,
        ),
      ),
    ),
  );
}
