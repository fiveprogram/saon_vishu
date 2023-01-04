import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/history/history_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    List<String> kari = ['カット', 'カラー', 'パーマ'];

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: '予約履歴', isJapanese: true),
      body: Consumer<HistoryModel>(
        builder: (context, model, child) {
          return FutureBuilder(
              future: model.addHistory(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        surfaceTintColor: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('2021年3月16日のご来店',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 15)),
                              const SizedBox(height: 7),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(3)),
                                      color: HexColor('#e28e7a'),
                                      border: Border.all(
                                        color: HexColor('#e28e7a'),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '全員',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.09,
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Wrap(
                                        children: kari
                                            .map(
                                              (treatmentDetail) => Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(4)),
                                                    color: HexColor('#989593'),
                                                    border: Border.all(
                                                      color:
                                                          HexColor('#989593'),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    treatmentDetail,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.01),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.09,
                                    width: width * 0.19,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black87),
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://storage.googleapis.com/hairlog-special/2018/11/2018110503.png'))),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 233,
                                        child: Text(
                                          'あなたのためにこだわったこだわりカラー♪ 今だけ特価1900円',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: const [
                                          Text(
                                            '5400',
                                            style: TextStyle(
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                          Text('▷'),
                                          Text('2900円'),
                                          SizedBox(width: 40),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: width * 0.3),
                                          const Text('施術時間： 120分',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
