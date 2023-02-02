import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/profile/cancel_guide/cancel_guide_model.dart';

class CancelGuidePage extends StatefulWidget {
  const CancelGuidePage({Key? key}) : super(key: key);

  @override
  State<CancelGuidePage> createState() => _CancelGuidePageState();
}

class _CancelGuidePageState extends State<CancelGuidePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'キャンセル方法', isJapanese: true),
      body: Consumer<CancelGuideModel>(
        builder: (context, model, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: height * 0.05,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black26),
                      ),
                    ),
                    child: const Text('キャンセルまでの手順',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Text(
                    '・手順①',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                  SizedBox(height: height * 0.01),
                  const Text(
                      'ページ下部のナビゲーションバーの項目の中の、「履歴」ページより、削除したいメニューを選択してください',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: height * 0.02),
                  Container(
                    height: height * 0.24,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('images/begin_cancel.jpg'))),
                  ),
                  SizedBox(height: height * 0.03),
                  const Divider(),
                  const Text(
                    '・手順②',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                  SizedBox(height: height * 0.01),
                  const Text('ページ下部に配置されている「キャンセルボタン」を押してください',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: height * 0.01),
                  Center(
                    child: Container(
                      height: height * 0.5,
                      width: width * 0.5,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('images/complete_cancel.PNG'))),
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  const Divider(),
                  const Text(
                    '以上にてキャンセルは完了になります。',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: height * 0.05),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
