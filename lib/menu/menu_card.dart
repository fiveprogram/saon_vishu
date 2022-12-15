import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MenuCard extends StatefulWidget {
  bool isForAll;
  MenuCard({required this.isForAll, super.key});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  List<String> hairHandling = ['ヘアトリートメント', 'カット', 'ヘアカラー', '縮毛矯正', 'シャンプー'];
  List<Widget> contentsOfHairList() {
    return hairHandling
        .map((e) => Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: Colors.grey,
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ))
        .toList();
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
                  targetCard(isForAll: widget.isForAll),
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
              Row(
                children: [FlutterLogo()],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget targetCard({required bool isForAll}) {
    return isForAll
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
}
