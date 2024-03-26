class SoldByModel {
  int? id;
  String? lastName;
  String? firstName;
  int? status;

  SoldByModel({this.id, this.lastName, this.firstName, this.status});

  SoldByModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    lastName = json['last_name'];
    firstName = json['first_name'];
    status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['last_name'] = lastName;
    data['first_name'] = firstName;
    data['status'] = status;
    return data;
  }
}
