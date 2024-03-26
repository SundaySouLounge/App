class UserInfoModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobile;
  String? cover;
  int? gender;
  String? type;
  String? fcmToken;
  String? stripeKey;
  String? extraField;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? selectedAcusticSoloValue;
  String? selectedAcusticDuoValue;
  String? selectedAcusticTrioValue;
  String? selectedAcusticQuarterValue;

  UserInfoModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.countryCode,
      this.mobile,
      this.cover,
      this.gender,
      this.type,
      this.fcmToken,
      this.stripeKey,
      this.extraField,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.selectedAcusticDuoValue,
      this.selectedAcusticQuarterValue,
      this.selectedAcusticSoloValue,
      this.selectedAcusticTrioValue});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    cover = json['cover'];
    gender = int.parse(json['gender'].toString());
    type = json['type'];
    fcmToken = json['fcm_token'];
    stripeKey = json['stripe_key'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    selectedAcusticSoloValue = json['acustic_solo'];
    selectedAcusticDuoValue= json['acustic_duo'] ;
    selectedAcusticQuarterValue = json['setup'] ;
    selectedAcusticTrioValue = json['acustic_trio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['mobile'] = mobile;
    data['cover'] = cover;
    data['gender'] = gender;
    data['type'] = type;
    data['fcm_token'] = fcmToken;
    data['stripe_key'] = stripeKey;
    data['extra_field'] = extraField;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['acustic_solo'] = selectedAcusticSoloValue;
    data['acustic_duo'] = selectedAcusticDuoValue;
    data['setup'] = selectedAcusticQuarterValue;
    data['acustic_trio'] = selectedAcusticTrioValue;
    return data;
  }
}
