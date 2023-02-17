import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salon_vishu/domain/menu.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectReservationDateModel extends ChangeNotifier {
  Menu menu;
  SelectReservationDateModel(this.menu);

  Future<void> directCallVishu(BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '0721-21-8824',
    );

    await launchUrl(launchUri);
  }

  List<Widget> contentsOfHairList(double height) {
    return menu.treatmentDetailList.map((treatmentDetail) {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: HexColor('#7a3425'),
            border: Border.all(
              color: HexColor('#7a3425'),
            ),
          ),
          child: Text(
            treatmentDetail,
            style: TextStyle(fontSize: height * 0.018, color: Colors.white),
          ),
        ),
      );
    }).toList();
  }
}
