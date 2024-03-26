class TimingModel {
  int? day;
  String? openTime;
  String? closeTime;

  TimingModel({this.day, this.openTime, this.closeTime});

  TimingModel.fromJson(Map<String, dynamic> json) {
    day = int.parse(json['day'].toString());
    openTime = json['open_time'];
    closeTime = json['close_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    return data;
  }
}
