class IndividualInfoModel {
  int? id;
  int? uid;
  String? background;
  String? categories;
  String? address;
  String? lat;
  String? lng;
  int? cid;
  String? about;
  double? rating;
  double? feeStart;
  int? totalRating;
  String? website;
  String? timing;
  String? images;
  String? zipcode;
  String? selectedAcusticSoloValue;
  String? selectedAcusticDuoValue;
  String? selectedAcusticTrioValue;
  String? selectedAcusticQuarterValue;
  String? weddingEditor;
  String? travelEditor; 
  String? selectedAcusticSoloValueInstrument;
  String? selectedAcusticDuoValueInstrument;
  String? selectedAcusticTrioValueInstrument;
  String? selectedAcusticQuarterValueInstrument;
  String? weddingEditorInstrument;
  int? verified;
  int? inHome;
  int? popular;
  int? haveShop;
  int? haveTrio;
  int? haveQuartet;
  String? extraField;
  int? status;
  List<WebCatesData>? webCatesData;
  CityData? cityData;
  String? bandName;
  String? contactName;
  String? contactNumber;

  IndividualInfoModel(
      {this.id,
      this.uid,
      this.background,
      this.categories,
      this.address,
      this.lat,
      this.lng,
      this.cid,
      this.about,
      this.rating,
      this.feeStart,
      this.totalRating,
      this.website,
      this.timing,
      this.images,
      this.zipcode,
      this.verified,
      this.inHome,
      this.popular,
      this.haveShop,
      this.extraField,
      this.status,
      this.webCatesData,
      this.cityData,
      this.selectedAcusticSoloValue,
      this.selectedAcusticDuoValue,
      this.selectedAcusticQuarterValue,
      this.selectedAcusticTrioValue,
      this.travelEditor,
      this.weddingEditor,
      this.selectedAcusticDuoValueInstrument,
      this.selectedAcusticQuarterValueInstrument,
      this.selectedAcusticSoloValueInstrument,
      this.selectedAcusticTrioValueInstrument,
      this.weddingEditorInstrument,
      this.haveQuartet,
      this.haveTrio,
      this.bandName,
      this.contactName,
      this.contactNumber});

  IndividualInfoModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    background = json['background'];
    categories = json['categories'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    cid = int.parse(json['cid'].toString());
    about = json['about'];
    rating = double.parse(json['rating'].toString());
    feeStart = double.parse(json['fee_start'].toString());
    totalRating = int.parse(json['total_rating'].toString());
    website = json['website'];
    timing = json['timing'];
    images = json['images'];
    zipcode = json['zipcode'];
    selectedAcusticSoloValue = json['acustic_solo'];
    selectedAcusticDuoValue = json['acustic_duo'];
    selectedAcusticQuarterValue = json['setup'];
    selectedAcusticTrioValue = json['acustic_trio'];
    selectedAcusticDuoValueInstrument = json['acustic_duoinstru'];
    selectedAcusticQuarterValueInstrument = json['acustic_quarterinstru'];
    selectedAcusticTrioValueInstrument = json['acustic_trioinstru'];
    selectedAcusticSoloValueInstrument = json['acustic_soloinstru'];
    weddingEditorInstrument = json['acustic_weddinginstru'];
    travelEditor = json['travel'];
    weddingEditor = json['wedding'];
    verified = int.parse(json['verified'].toString());
    inHome = int.parse(json['in_home'].toString());
    haveQuartet = int.parse(json['quartetcheck'].toString());
    haveTrio = int.parse(json['triocheck'].toString());
    popular = int.parse(json['popular'].toString());
    haveShop = int.parse(json['have_shop'].toString());
    bandName = json['band_name'];
    contactName = json['contact_name'];
    contactNumber = json['contact_number'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
    if (json['web_cates_data'] != null) {
      webCatesData = <WebCatesData>[];
      json['web_cates_data'].forEach((v) {
        webCatesData!.add(WebCatesData.fromJson(v));
      });
    }
    cityData =
        json['city_data'] != null ? CityData.fromJson(json['city_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['background'] = background;
    data['categories'] = categories;
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['cid'] = cid;
    data['about'] = about;
    data['rating'] = rating;
    data['fee_start'] = feeStart;
    data['total_rating'] = totalRating;
    data['website'] = website;
    data['timing'] = timing;
    data['images'] = images;
    data['zipcode'] = zipcode;
    data['verified'] = verified;
    data['in_home'] = inHome;
    data['popular'] = popular;
    data['have_shop'] = haveShop;
    data['extra_field'] = extraField;
    data['status'] = status;
    data['acustic_solo'] = selectedAcusticSoloValue;
    data['acustic_duo'] = selectedAcusticDuoValue;
    data['setup'] = selectedAcusticQuarterValue;
    data['acustic_trio'] = selectedAcusticTrioValue;
    data['travel'] = travelEditor;
    data['wedding']= weddingEditor;
    data['acustic_duoinstru'] = selectedAcusticDuoValueInstrument;
    data['acustic_quarterinstru'] = selectedAcusticQuarterValueInstrument;
    data['acustic_trioinstru'] = selectedAcusticTrioValueInstrument;
    data['acustic_soloinstru'] = selectedAcusticSoloValueInstrument;
    data['acustic_weddinginstru'] = weddingEditorInstrument;
    data['quartetcheck']= haveQuartet;
    data['triocheck']= haveTrio;
    data['band_name'] = bandName;
    data['contact_name'] = contactName;
    data['contact_number'] = contactNumber;
    
    if (webCatesData != null) {
    data['web_cates_data'] = webCatesData!.map((v) => v.toJson()).toList();
  }
    if (cityData != null) {
      data['city_data'] = cityData!.toJson();
    }
    return data;
  }

    String getMusicGroupType() {
        List<String> types = [];

        
        if (haveShop == 1) {
          types.add('Solo');
        }
        if (inHome == 1) {
          types.add('Duo');
        }
        if (haveTrio == 1) {
          types.add('Trio');
        }
        if (haveQuartet == 1) {
          types.add('Quartet or Higher');
        }

        return types.isNotEmpty ? types.join(', ') : '';
      }
}

class WebCatesData {
  int? id;
  String? name;
  String? cover;
  String? extraField;
  int? status;
  

  WebCatesData({this.id, this.name, this.cover, this.extraField, this.status});

  WebCatesData.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    cover = json['cover'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
    print('sent');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
  void updateCover(String? newCover) {
    cover = newCover;
  }
}

class CityData {
  int? id;
  String? name;
  String? lat;
  String? lng;
  String? extraField;
  int? status;

  CityData(
      {this.id, this.name, this.lat, this.lng, this.extraField, this.status});

  CityData.fromJson(Map<String, dynamic> json) {
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
