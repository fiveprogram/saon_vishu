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

    await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('0721-21-8824'),
              content: const Text('電話しますか？'),
              actions: [
                CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("戻る")),
                CupertinoButton(
                    onPressed: () {
                      launchUrl(launchUri);
                    },
                    child: const Text("OK"))
              ],
            ));
  }

  List<Widget> contentsOfHairList(double height) {
    return menu.treatmentDetailList.map((treatmentDetail) {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: HexColor('#7e796e'),
            border: Border.all(
              color: HexColor('#7e796e'),
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

  //対象者を表す
  Widget targetCard(double height, double width) {
    HexColor targetColor(String targetMember) {
      switch (targetMember) {
        case '新規':
          return HexColor('#344eba');
        case '再来':
          return HexColor('#73e600');
        case '全員':
          return HexColor('#e28e7a');
        default:
          return HexColor('#ff8db4');
      }
    }

    return Container(
      width: width * 0.12,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        color: targetColor(menu.targetMember),
        border: Border.all(
          color: targetColor(menu.targetMember),
        ),
      ),
      child: Center(
        child: Text(
          menu.targetMember,
          style: TextStyle(color: Colors.white, fontSize: height * 0.018),
        ),
      ),
    );
  }
}
