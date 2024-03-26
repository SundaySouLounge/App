class GooglePlacesModel {
  String? description;
  String? placeId;
  String? reference;
  GooglePlacesModel({this.description, this.placeId, this.reference});
  GooglePlacesModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    placeId = json['place_id'];
    reference = json['reference'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['place_id'] = placeId;
    data['reference'] = reference;
    return data;
  }
}
