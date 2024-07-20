import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';
import 'package:get/get.dart';

CitiesCategoriesParse({
    this.categoryId,
    this.categoryName,
    this.cities,
  });

  CitiesCategoriesParse.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    cities = json['cities'] != null ? List<String>.from(json['cities']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    if (this.cities != null) {
      data['cities'] = this.cities;
    }
    return data;
  }
}
