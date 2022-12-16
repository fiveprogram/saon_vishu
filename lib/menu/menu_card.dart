import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// ignore: must_be_immutable
class MenuCard extends StatefulWidget {
  bool isTargetAllMember;
  MenuCard({required this.isTargetAllMember, super.key});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  List<String> treatmentDetailList = [
    'ヘアトリートメント',
    'カット',
    'ヘアカラー',
    '縮毛矯正',
    'シャンプー'
  ];

  List<Widget> contentsOfHairList() {
    return treatmentDetailList
        .map(
          (e) => Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: HexColor('#949886'),
                border: Border.all(
                  color: HexColor('#949886'),
                ),
              ),
              child: Text(
                e,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        )
        .toList();
  }

  Widget targetCard({required bool isTargetAllMember}) {
    return isTargetAllMember
        ? Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.blue,
              border: Border.all(color: Colors.blue),
            ),
            child: const Text(
              '全員',
              style: TextStyle(color: Colors.white),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: Colors.red,
              border: Border.all(color: Colors.red),
            ),
            child: const Text(
              '新規',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  targetCard(isTargetAllMember: widget.isTargetAllMember),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        children: contentsOfHairList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: const [FlutterLogo(size: 90)],
              )
            ],
          ),
        ),
      ),
    );
  }
}
