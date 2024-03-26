class SlotTimeModel {
  String? startTime;
  String? endTime;
  SlotTimeModel({this.startTime, this.endTime});
  SlotTimeModel.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
