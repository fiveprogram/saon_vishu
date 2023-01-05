class MyReservationHistory {
  DateTime reservationDate;
  String menuName;
  String treatmentExplain;
  String imgURL;
  int treatmentTime;
  List<String> treatmentContentList;

  MyReservationHistory(
      {required this.reservationDate,
      required this.menuName,
      required this.treatmentExplain,
      required this.imgURL,
      required this.treatmentTime,
      required this.treatmentContentList});
}
