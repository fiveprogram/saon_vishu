import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/master/rest_date_register/rest_date_register_model.dart';

class RestDateRegisterPage extends StatefulWidget {
  const RestDateRegisterPage({Key? key}) : super(key: key);

  @override
  State<RestDateRegisterPage> createState() => _RestDateRegisterPageState();
}

class _RestDateRegisterPageState extends State<RestDateRegisterPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: HexColor('#fffffe'),
      appBar: vishuAppBar(appBarTitle: 'Rest'),
      body: Consumer<RestDateRegisterModel>(
        builder: (context, model, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('休憩設定',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: height * 0.4,
                  width: width * 0.95,
                  decoration: BoxDecoration(border: Border.all()),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        height: height * 0.20,
                        width: width * 0.06,
                        decoration: BoxDecoration(border: Border.all()),
                        child: const Icon(Icons.watch_later_outlined),
                      ),
                      SizedBox(width: width * 0.02),
                      Container(
                        alignment: Alignment.topLeft,
                        height: height * 0.20,
                        width: width * 0.2,
                        decoration: BoxDecoration(border: Border.all()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '終日',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              onTap: () async {
                                model.getDate(context);
                              },
                              readOnly: true,
                              controller: model.startDateController,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                  hintText: '開始日', border: InputBorder.none),
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: model.endDateController,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                  hintText: '終了日', border: InputBorder.none),
                              onTap: () async {
                                model.getDate(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.05),
                      Container(
                        alignment: Alignment.topCenter,
                        height: height * 0.20,
                        width: width * 0.1,
                        decoration: BoxDecoration(border: Border.all()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Transform.scale(
                              scale: 0.9,
                              child: CupertinoSwitch(
                                  value: model.isAllDay,
                                  onChanged: (_) {
                                    setState(() {
                                      model.isAllDay = !model.isAllDay;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                    hintText: '終了時刻',
                    suffixIcon: Icon(Icons.calendar_month),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70),
              ),
              SizedBox(height: height * 0.05),
              SizedBox(
                  width: width * 0.3,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor('#a48d77')),
                      onPressed: () {},
                      child: const Text(
                        '確定',
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.bold),
                      )))
            ],
          );
        },
      ),
    );
  }
}
