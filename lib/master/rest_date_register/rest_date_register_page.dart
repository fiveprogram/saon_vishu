import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
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
    final width = MediaQuery.of(context).size.width;

    return Consumer<RestDateRegisterModel>(builder: (context, model, child) {
      return WillPopScope(
        onWillPop: () async {
          return model.willPopCallback(context);
        },
        child: Scaffold(
          backgroundColor: HexColor('#fffffe'),
          appBar: PreferredSize(
            preferredSize: const Size(
              double.infinity,
              56.0,
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: AppBar(
                  actions: [
                    TextButton(
                        onPressed: () {
                          model.registerRestOwnerTime(context);
                        },
                        child: const Text('登録',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)))
                  ],
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  backgroundColor: HexColor("#989593"),
                  title: const Text('Rest',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily: 'Dancing_Script')),
                  elevation: 10.0,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: height * 0.06,
                  alignment: Alignment.center,
                  child: const Text('休憩時間をタップしてください',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white70,
                      border: Border(top: BorderSide(color: Colors.black26))),
                  height: height * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            model.previousWeek = model.previousWeek + 1;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black38,
                        ),
                      ),
                      Text(
                          '${model.weekDayList(model.currentDisplayDate())[1].month}月',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            model.previousWeek = model.previousWeek - 1;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black26)),
                          height: height * 0.05,
                          width: width * 0.157,
                        ),
                        ...model
                            .separateThirtyMinutes(model.currentDisplayDate())
                            .map(
                          (thirtyMinute) {
                            return Container(
                              alignment: Alignment.center,
                              height: height * 0.06,
                              width: width * 0.157,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black38),
                              ),
                              child: Text(
                                  model.businessTimeFormatter
                                      .format(thirtyMinute),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            );
                          },
                        ),
                      ],
                    ),
                    ...model.weekDayList(model.currentDisplayDate()).map(
                          (weekDay) => Column(
                            children: [
                              Container(
                                height: height * 0.05,
                                width: width * 0.12,
                                decoration: BoxDecoration(
                                  color: model.dowBoxColor(
                                      model.dayOfWeekFormatter.format(weekDay)),
                                  border: Border.all(color: Colors.black38),
                                ),
                                child: Text(
                                    '${weekDay.day}日\n${model.dayOfWeekFormatter.format(weekDay)}',
                                    textAlign: TextAlign.center),
                              ),
                              ...model.separateThirtyMinutes(weekDay).map(
                                (thirtyMinute) {
                                  return GestureDetector(
                                    onTap:
                                        model.isNotAlreadyReserved(thirtyMinute)
                                            ? () {
                                                model.onCellTap(thirtyMinute);
                                              }
                                            : null,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: height * 0.06,
                                      width: width * 0.12,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:
                                            Border.all(color: Colors.black38),
                                      ),
                                      child: Text(model.cellLabel(thirtyMinute),
                                          style: model.isNotAlreadyReserved(
                                                  thirtyMinute)
                                              ? TextStyle(
                                                  color: HexColor('#fc7ea0'),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)
                                              : TextStyle(
                                                  color: HexColor('#8f948a'),
                                                  fontSize: 20),
                                          textAlign: TextAlign.center),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
