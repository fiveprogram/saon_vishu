import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/domain/reservation.dart';
import 'package:salon_vishu/master/booker_calendar/booker_calendar_model.dart';
import 'package:salon_vishu/master/booker_detail/booker_detail_page.dart';
import 'package:table_calendar/table_calendar.dart';

class BookerCalendarPage extends StatefulWidget {
  const BookerCalendarPage({Key? key}) : super(key: key);

  @override
  State<BookerCalendarPage> createState() => _BookerCalendarPageState();
}

class _BookerCalendarPageState extends State<BookerCalendarPage> {
  @override
  Widget build(BuildContext context) {
    late final ValueNotifier<List<Reservation>> selectedEvents;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<BookerCalendarModel>(builder: (context, model, child) {
      if (model.reservationList.isEmpty) {
        return const CircularProgressIndicator();
      }
      selectedEvents = ValueNotifier(model.getEventsForDay(model.focusedDate));

      return Scaffold(
        backgroundColor: HexColor('#fcf8f6'),
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
                  IconButton(
                      onPressed: () {
                        model.signOut(context);
                      },
                      icon: const Icon(Icons.logout))
                ],
                systemOverlayStyle: SystemUiOverlayStyle.light,
                backgroundColor: HexColor("#989593"),
                title: const Text('予約者カレンダー',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    )),
                elevation: 10.0,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            TableCalendar(
              focusedDay: model.focusedDate,
              firstDay: model.today.add(const Duration(days: -100)),
              lastDay: model.today.add(const Duration(days: 365)),
              selectedDayPredicate: (DateTime day) {
                return isSameDay(model.selectedDate, day);
              },
              onDaySelected: (selectedDate, focusedDay) {
                setState(() {
                  model.selectedDate = selectedDate;
                  model.focusedDate = focusedDay;
                });
              },
              calendarFormat: model.calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  model.calendarFormat = format;
                });
              },
              locale: 'ja_JP',
              eventLoader: (day) {
                return model.getEventsForDay(day);
              },
              onPageChanged: (focusedDay) {
                model.focusedDate = focusedDay;
              },
            ),
            const Divider(),
            Expanded(
              child: ValueListenableBuilder<List<Reservation>>(
                valueListenable: selectedEvents,
                builder: (context, value, _) {
                  return value.isNotEmpty
                      ? ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            value.sort((a, b) => a.startTime
                                .toDate()
                                .hour
                                .compareTo(b.startTime.toDate().hour));
                            Reservation reservation = value[index];

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: ((context) =>
                                              BookerDetailPage(
                                                reservation: reservation,
                                              ))));
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ...reservation.treatmentDetailList
                                            .map(
                                              (treatmentDetail) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 1),
                                                child: Container(
                                                  height: height * 0.03,
                                                  width: width * 0.06,
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange,
                                                    border: Border.all(
                                                        color: Colors.orange),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                      model.menuBlock(
                                                          treatmentDetail),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        SizedBox(width: width * 0.02),
                                        Text(model.startTimeFormatter.format(
                                            reservation.startTime.toDate())),
                                        Text(model.endTimeFormatter.format(
                                            reservation.finishTime.toDate())),
                                      ],
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1),
                                          child: Container(
                                            height: height * 0.03,
                                            width: width * 0.06,
                                            decoration: BoxDecoration(
                                              color: model.targetColor(
                                                  reservation.targetMember),
                                              border: Border.all(
                                                color: model.targetColor(
                                                    reservation.targetMember),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                                reservation.targetMember,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                        SizedBox(width: width * 0.02),
                                        Text(
                                          reservation.name,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        if (reservation.lastVisit == null)
                                          const Text('初来店になります。'),
                                        if (reservation.lastVisit != null)
                                          Text(
                                              '前回来店：${model.lastVisitFormatter.format(reservation.lastVisit!.toDate())}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Text(
                          '本日ご予約はございません',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
