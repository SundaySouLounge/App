class BookedSlotModel {
  String? slot;
  BookedSlotModel({this.slot});
  BookedSlotModel.fromJson(Map<String, dynamic> json) {
    slot = json['slot'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slot'] = slot;
    return data;
  }
}
