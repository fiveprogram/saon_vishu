import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon_vishu/domain/information_salon_detail.dart';

class SalonInfoModel extends ChangeNotifier {
  CarouselController buttonCarouselController = CarouselController();
  int activeIndex = 0;
  InformationSalonDetail? info;
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

  void changeNextPage() {
    buttonCarouselController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    notifyListeners();
  }

  void changePreviousPage() {
    buttonCarouselController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    notifyListeners();
  }
}
