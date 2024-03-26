class EventContractModel {
  int? id;
  int? userId;
  int? salonId;
  int? salonUid;
  int? individualUid;
  int? individualId;
  DateTime? date;
  String? time;
  String? bandSize;
  double? fee;
  String? extraField;
  String? status;
  String? suggester;
  String? addressVenue;
  String? nameVenue;
  String? venueMobile;
  String? musician;
  String? bodys;
  String? paymentMethod;

  EventContractModel({
    this.id,
    this.userId,
    this.salonId,
    this.individualId,
    this.salonUid,
    this.individualUid,
    this.date,
    this.time,
    this.bandSize,
    this.fee,
    this.extraField,
    this.status,
    this.suggester,
    this.addressVenue,
    this.nameVenue,
    this.venueMobile,
    this.musician,
    this.bodys,
    this.paymentMethod,
  });

  EventContractModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.parse(json['id'].toString()) : null;
    userId =
        json['user_id'] != null ? int.parse(json['user_id'].toString()) : null;
    salonId = json['salon_id'] != null
        ? int.parse(json['salon_id'].toString())
        : null;
    individualId = json['individual_id'] != null
        ? int.parse(json['individual_id'].toString())
        : null;
    salonUid = json['salon_uid'] != null
        ? int.parse(json['salon_uid'].toString())
        : null;
    individualUid = json['individual_uid'] != null
        ? int.parse(json['individual_uid'].toString())
        : null;
    date = DateTime.parse(json['date'].toString()).toUtc();
    time = json['time'];
    bandSize = json['band_size'];
    fee = json['fee'] != null ? double.parse(json['fee'].toString()) : null;
    extraField = json['extra_field'] ?? '';
    status = json['status'] ?? '';
    suggester = json['suggester'] ?? '';
    addressVenue = json['venue_address'] ?? '';
    nameVenue = json['venue_name'] ?? '';
    venueMobile = json['mobile'] ?? '';
    musician = json['musician'] ?? '';
    bodys = json['body'] ?? '';
    paymentMethod = json['payment_method'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['salon_id'] = salonId;
    data['individual_id'] = individualId;
    data['salon_uid'] = salonUid;
    data['individual_uid'] = individualUid;
    data['date'] = date != null ? date!.toIso8601String() : null;
    data['time'] = time;
    data['band_size'] = bandSize;
    data['fee'] = fee;
    data['extra_field'] = extraField;
    data['status'] = status;
    data['suggester'] = suggester;
    data['venue_address'] = addressVenue;
    data['venue_name'] = nameVenue;
    data['mobile'] = venueMobile;
    data['musician'] = musician;
    data['body'] = bodys;
    data['payment_method'] = paymentMethod;
    return data;
  }
}
