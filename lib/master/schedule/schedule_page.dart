import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/master/schedule/schedule_model.dart';

import '../../common_widget/vishu_app_bar.dart';
import '../rest_date_register/rest_date_register_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: HexColor('#fffffe'),
      appBar: vishuAppBar(appBarTitle: 'schedule'),
      body: Consumer<ScheduleModel>(
        builder: (context, model, child) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: height * 0.06,
                  alignment: Alignment.center,
                  child: const Text('今後の予定',
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
                                  style: TextStyle(
                                      fontSize: height * 0.016,
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
                                      model.dayOfWeekFormatter.format(weekDay),
                                      weekDay),
                                  border: Border.all(color: Colors.black38),
                                ),
                                child: Text(
                                    '${weekDay.day}日\n${model.dayOfWeekFormatter.format(weekDay)}',
                                    style: TextStyle(
                                        fontSize: height * 0.016,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ),
                              ...model.separateThirtyMinutes(weekDay).map(
                                (thirtyMinute) {
                                  return Container(
                                    alignment: Alignment.center,
                                    height: height * 0.06,
                                    width: width * 0.12,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black38),
                                    ),
                                    child: Text(
                                        model.isAvailable(thirtyMinute)
                                            ? '○'
                                            : '✖︎',
                                        style: model.isAvailable(thirtyMinute)
                                            ? TextStyle(
                                                color: HexColor('#fc7ea0'),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)
                                            : TextStyle(
                                                color: HexColor('#8f948a'),
                                                fontSize: 20),
                                        textAlign: TextAlign.center),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const RestDateRegisterPage()));
          },
          child: const Icon(Icons.edit)),
    );
  }
}
