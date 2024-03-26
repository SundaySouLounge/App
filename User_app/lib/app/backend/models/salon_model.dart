class SalonModel {
  int? id;
  int? uid;
  String? name;
  double? rating;
  int? totalRating;
  String? address;
  String? cover;
  double? distance;
  double? salonLat;
  double? salonLng;

  SalonModel(
      {this.id,
      this.uid,
      this.name,
      this.rating,
      this.totalRating,
      this.address,
      this.cover,
      this.distance,
      this.salonLat,
      this.salonLng});

  SalonModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    name = json['name'];
    rating = double.parse(json['rating'].toString());
    totalRating = int.parse(json['total_rating'].toString());
    address = json['address'];
    cover = json['cover'];
    distance = double.parse(json['distance'].toString());
    salonLat = double.parse(json['salon_lat'].toString());
    salonLng = double.parse(json['salon_lng'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['name'] = name;
    data['rating'] = rating;
    data['total_rating'] = totalRating;
    data['address'] = address;
    data['cover'] = cover;
    data['distance'] = distance;
    data['salon_lat'] = salonLat;
    data['salon_lng'] = salonLng;
    return data;
  }
}
