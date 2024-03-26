class CalendarEventModel {
  int? id;
  int? uid;
  String? title;
  String? eventDate;
  String? eventLink;

  CalendarEventModel({
    this.id,
    this.uid,
    this.title,
    this.eventDate,
    this.eventLink,
  });

  CalendarEventModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    title = json['title'];
    eventDate = json['event_date'];
    eventLink = json['event_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['title'] = title;
    data['event_date'] = eventDate;
    data['event_link'] = eventLink;
    return data;
  }
}
