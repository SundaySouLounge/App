import 'dart:convert';

class UnavailableDatesModel {
  int? id;
  int? userId;
  int? salonId;
  int? individualId;
  List<DateTime>? dates;

  UnavailableDatesModel({
    this.id,
    this.userId,
    this.salonId,
    this.individualId,
    this.dates,
  });

  UnavailableDatesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.parse(json['id'].toString()) : null;
    userId =
        json['user_id'] != null ? int.parse(json['user_id'].toString()) : null;
    salonId = json['salon_id'] != null
        ? int.parse(json['salon_id'].toString())
        : null;
    individualId = json['individual_id'] != null
        ? int.parse(json['individual_id'].toString())
        : null;
    dates = json['dates'] != null
        ? jsonDecode(json['dates'])
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['salon_id'] = salonId;
    data['individual_id'] = individualId;
    return data;
  }
}
