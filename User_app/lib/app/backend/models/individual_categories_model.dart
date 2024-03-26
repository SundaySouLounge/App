class IndividualCategoriesModel {
  int? id;
  int? uid;
  List<Categories>? categories;
  double? distance;
  UserInfo? userInfo;

  IndividualCategoriesModel(
      {this.id, this.uid, this.categories, this.distance, this.userInfo});

  IndividualCategoriesModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    distance = double.parse(json['distance'].toString());
    userInfo =
        json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    data['distance'] = distance;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? cover;

  Categories({this.id, this.name, this.cover});

  Categories.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    return data;
  }
}

class UserInfo {
  String? firstName;
  String? lastName;
  String? cover;
  String? selectedAcusticSoloValue;
  String? selectedAcusticDuoValue;
  String? selectedAcusticTrioValue;
  String? selectedAcusticQuarterValue;

  UserInfo({this.firstName, this.lastName, this.cover, this.selectedAcusticDuoValue, this.selectedAcusticQuarterValue, this.selectedAcusticSoloValue, this.selectedAcusticTrioValue,});

  UserInfo.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    cover = json['cover'];
    selectedAcusticSoloValue = json['acustic_solo'];
    selectedAcusticDuoValue= json['acustic_duo'] ;
    selectedAcusticQuarterValue = json['setup'] ;
    selectedAcusticTrioValue = json['acustic_trio'];
    print("tits");
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['cover'] = cover;
    data['acustic_solo'] = selectedAcusticSoloValue;
    data['acustic_duo'] = selectedAcusticDuoValue;
    data['setup'] = selectedAcusticQuarterValue;
    data['acustic_trio'] = selectedAcusticTrioValue;
    return data;
  }
}
