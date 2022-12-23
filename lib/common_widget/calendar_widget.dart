import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../select_reservation_date/select_reservation_date_model.dart';

class CalenderWidget extends StatefulWidget {
  const CalenderWidget({Key? key}) : super(key: key);

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectReservationDateModel>(
      builder: (context, model, child) {
        final double deviceHeight = MediaQuery.of(context).size.height;
        final double deviceWidth = MediaQuery.of(context).size.width;

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: deviceHeight / 15,
                width: deviceWidth,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: ListTile(
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                  title: Center(
                    child: Text(
                      '${model.calendar.month}月',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: deviceHeight / 15,
                    width: deviceWidth / 8,
                    decoration: BoxDecoration(border: Border.all()),
                  ),
                  Row(
                    children: model.dateColumn(
                        height: deviceHeight, width: deviceWidth),
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: model.timeList(
                        height: deviceHeight, width: deviceWidth),
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
