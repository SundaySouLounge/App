class IndividualModel {
  int? id;
  int? uid;
  double? lat;
  double? lng;
  double? distance;
  UserInfo? userInfo;
  int? popular;

  IndividualModel(
      {this.id, this.uid, this.distance, this.userInfo, this.popular});

  IndividualModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    distance = double.parse(json['distance'].toString());
    lat = double.parse(json['lat'].toString());
    lng = double.parse(json['lng'].toString());
    popular = int.parse(json['popular']?.toString() ?? "0");
    userInfo =
        json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['lat'] = lat;
    data['lng'] = lng;
    data['distance'] = distance;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    data['popular'] = popular;
    return data;
  }
}

class UserInfo {
  String? firstName;
  String? lastName;
  String? cover;

  UserInfo({this.firstName, this.lastName, this.cover});

  UserInfo.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['cover'] = cover;
    return data;
  }
}
