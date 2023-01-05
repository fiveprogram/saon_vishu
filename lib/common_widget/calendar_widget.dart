// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../confirm_reservation/confirm_reservation_page.dart';
import '../domain/menu.dart';
import '../domain/profile.dart';
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
        Profile? profile = model.profile;
        if (profile == null) {
          return const CircularProgressIndicator();
        }

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
                          model.thisWeek = model.thisWeek - 1;
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
                          model.thisWeek = model.thisWeek + 1;
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
                                return GestureDetector(
                                  onTap: model.isAvailable(
                                          thirtyMinute, widget.menu)
                                      ? () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmReservationPage(
                                                          menu: widget.menu,
                                                          startTime:
                                                              thirtyMinute,
                                                          profile: profile)));
                                        }
                                      : null,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: height * 0.06,
                                    width: width * 0.12,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black38),
                                    ),
                                    child: Text(
                                        model.isAvailable(
                                                thirtyMinute, widget.menu)
                                            ? '○'
                                            : '✖︎',
                                        style: model.isAvailable(
                                                thirtyMinute, widget.menu)
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
        );
      },
    );
  }
}
