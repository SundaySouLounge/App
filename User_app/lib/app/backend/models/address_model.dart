class AddressModel {
  int? id;
  int? uid;
  int? title;
  String? address;
  String? house;
  String? landmark;
  String? pincode;
  String? lat;
  String? lng;
  String? extraField;
  int? status;

  AddressModel(
      {this.id,
      this.uid,
      this.title,
      this.address,
      this.house,
      this.landmark,
      this.pincode,
      this.lat,
      this.lng,
      this.extraField,
      this.status});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    title = int.parse(json['title'].toString());
    address = json['address'];
    house = json['house'];
    landmark = json['landmark'];
    pincode = json['pincode'];
    lat = json['lat'];
    lng = json['lng'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['title'] = title;
    data['address'] = address;
    data['house'] = house;
    data['landmark'] = landmark;
    data['pincode'] = pincode;
    data['lat'] = lat;
    data['lng'] = lng;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
