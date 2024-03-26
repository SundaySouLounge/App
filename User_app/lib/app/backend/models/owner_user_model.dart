class OwnerUserModel {
  int? id;
  String? firstName;
  String? lastName;
  String? type;

  OwnerUserModel({this.id, this.firstName, this.lastName, this.type});

  OwnerUserModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    firstName = json['first_name'];
    lastName = json['last_name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['type'] = type;
    return data;
  }
}
