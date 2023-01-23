import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon_vishu/domain/information_salon_detail.dart';
import 'package:salon_vishu/domain/version.dart';

class SalonInfoModel extends ChangeNotifier {
  CarouselController buttonCarouselController = CarouselController();
  int activeIndex = 0;
  InformationSalonDetail? info;
  Version? version;
  ScrollController scrollController = ScrollController();

  Future<void> fetchInfo() async {
    final infoStream = FirebaseFirestore.instance
        .collection('info')
        .doc('huFQ5Ce617QfobIRdiH3')
        .snapshots();

    infoStream.listen((snapshot) {
      info = InformationSalonDetail.fromFirestore(snapshot);
      notifyListeners();
    });
  }

  Future<void> fetchVersion() async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> versionStream =
        FirebaseFirestore.instance
            .collection('force_update')
            .doc('uHoECUdMBarAX1H61FTC')
            .snapshots();

    versionStream.listen((snapshot) {
      version = Version.fromFirestore(snapshot);
      notifyListeners();
    });
  }
}
