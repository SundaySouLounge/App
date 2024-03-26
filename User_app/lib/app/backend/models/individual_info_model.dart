import 'dart:convert';

import 'package:app_user/app/backend/models/timing_model.dart';

class IndividualInfoModel {
  int? id;
  int? uid;
  String? background;
  String? categories;
  String? address;
  double? lat;
  double? lng;
  int? cid;
  String? about;
  double? rating;
  double? feeStart;
  int? totalRating;
  String? website;
  List<TimingModel>? timing;
  String? images;
  String? zipcode;
  int? verified;
  int? inHome;
  int? popular;
  int? haveShop;
  String? extraField;
  String? email;
  String? mobile;
  int? status;
  int? isFavorite;
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
  int? haveTrio;
  int? haveQuartet;
  

  IndividualInfoModel({
    this.id,
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
    this.email,
    this.mobile,
    this.status,
    this.isFavorite,
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
    this.haveTrio});

  IndividualInfoModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    background = json['background'];
    categories = json['categories'];
    address = json['address'];
    lat = double.parse(json['lat'].toString());
    lng = double.parse(json['lng'].toString());
    cid = int.parse(json['cid'].toString());
    about = json['about'];
    selectedAcusticSoloValue = json['acustic_solo'];
    selectedAcusticDuoValue = json['acustic_duo'];
    selectedAcusticQuarterValue = json['setup'];
    selectedAcusticTrioValue = json['acustic_trio'];
    travelEditor = json['travel'];
    weddingEditor = json['wedding'];
    rating = double.parse(json['rating'].toString());
    feeStart = double.parse(json['fee_start'].toString());
    totalRating = int.parse(json['total_rating'].toString());
    website = json['website'];
    selectedAcusticDuoValueInstrument = json['acustic_duoinstru'];
    selectedAcusticQuarterValueInstrument = json['acustic_quarterinstru'];
    selectedAcusticTrioValueInstrument = json['acustic_trioinstru'];
    selectedAcusticSoloValueInstrument = json['acustic_soloinstru'];
    weddingEditorInstrument = json['acustic_weddinginstru'];
    if (json['timing'] != null &&
        json['timing'] != 'NA' &&
        json['timing'] != '') {
      timing = <TimingModel>[];
      var items = jsonDecode(json['timing']);
      items.forEach((v) {
        timing!.add(TimingModel.fromJson(v));
      });
    } else {
      timing = [];
    }
    images = json['images'];
    zipcode = json['zipcode'];
    verified = int.parse(json['verified'].toString());
    inHome = int.parse(json['in_home'].toString());
    popular = int.parse(json['popular'].toString());
    haveShop = int.parse(json['have_shop'].toString());
    haveQuartet = int.parse(json['quartetcheck'].toString());
    haveTrio = int.parse(json['triocheck'].toString());
    extraField = json['extra_field'];
    email = json['email'];
    mobile = json['mobile'];
    status = int.parse(json['status'].toString());
    isFavorite = int.parse(json['is_favorite'] != null ? json['is_favorite'].toString() : '0');
  }

  List<String> getCategoryTitles() {
        print('Categories one: $categories');

        try {
          if (categories != null && categories != 'NA' && categories != '') {
            List<dynamic> categoryList = jsonDecode(categories!);
            return categoryList.map((category) => category['title'].toString()).toList();
          } else {
            return [categories ?? ''];
          }
        } catch (e) {
          print('Error decoding categories: $e');
          return [];
        }
      }

      String getMusicGroupType() {
        List<String> types = [];

        if (haveShop  == 1) {
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
    data['email'] = email;
    data['mobile'] = mobile;
    data['status'] = status;
    data['is_favorite'] = isFavorite;
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
    return data;
  }
}

