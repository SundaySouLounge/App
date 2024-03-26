import 'dart:convert';

import 'package:ultimate_band_owner_flutter/app/backend/models/slots_model.dart';

class SlotListModel {
  int? id;
  int? uid;
  int? weekId;
  List<SlotsModel>? slots;
  String? extraField;
  int? status;

  SlotListModel(
      {this.id,
      this.uid,
      this.weekId,
      this.slots,
      this.extraField,
      this.status});

  SlotListModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    weekId = int.parse(json['week_id'].toString());
    // slots = json['slots'];
    if (json['slots'] != null && json['slots'] != 'NA' && json['slots'] != '') {
      slots = <SlotsModel>[];
      var items = jsonDecode(json['slots']);
      items.forEach((element) {
        slots!.add(SlotsModel.fromJson(element));
      });
    }
    // if (json['items'] != null) {
    //   items = <Items>[];
    //   json['items'].forEach((v) {
    //     items!.add(Items.fromJson(v));
    //   });
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['week_id'] = weekId;
    data['slots'] = slots;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
