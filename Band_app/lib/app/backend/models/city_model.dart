class CityModal {
  int? id;
  String? name;
  String? lat;
  String? lng;
  String? extraField;
  int? status;

  CityModal(
      {this.id, this.name, this.lat, this.lng, this.extraField, this.status});

  CityModal.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['lat'] = lat;
    data['lng'] = lng;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
