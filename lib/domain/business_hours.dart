class BusinessHours {
  const BusinessHours(
    this.openTimeHour,
    this.openTimeMinute,
    this.closeTimeHour,
    this.closeTimeMinute,
  );
  //営業開始時刻(h)
  final int openTimeHour;
  //営業開始時刻(m)
  final int openTimeMinute;
  //営業終了時刻(h)
  final int closeTimeHour;
  //営業終了時刻(m)
  final int closeTimeMinute;
}
