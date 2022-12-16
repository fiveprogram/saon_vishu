import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  bool isForAll = true;
  List<String> outlineCutOfContentList;
  String contentOfCut;
  String beforePrice;
  String afterPrice;

  Menu(
      {required this.isForAll,
      required this.outlineCutOfContentList,
      required this.contentOfCut,
      required this.beforePrice,
      required this.afterPrice});

  factory Menu.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Menu(
        isForAll: data['isForAll'],
        outlineCutOfContentList: data['outlineCutOfContentList'],
        contentOfCut: data['contentOfCut'],
        beforePrice: data['beforePrice'],
        afterPrice: data['afterPrice']);
  }
}
