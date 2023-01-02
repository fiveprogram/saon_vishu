import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/menu.dart';
import 'calendar_model.dart';

// ignore: must_be_immutable
class CalenderWidget extends StatefulWidget {
  Menu menu;
  CalenderWidget({required this.menu, Key? key}) : super(key: key);

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<CalendarModel>(
      builder: (context, model, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: height * 0.06,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          model.previousWeeks = model.previousWeeks + 1;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black38,
                      ),
                    ),
                    Text(
                        '${model.weekDateList(model.currentDisplayDate())[1].month}月',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          model.previousWeeks = model.previousWeeks - 1;
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
                            height: height * 0.06,
                            width: width * 0.157,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black38),
                            ),
                            child: Text(model.businessTimeFormatter
                                .format(thirtyMinute)),
                          );
                        },
                      ),
                    ],
                  ),
                  ...model.weekDateList(model.currentDisplayDate()).map(
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
                                return Container(
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
    );
  }
}
