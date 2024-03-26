class VideoModel {
  int? id;
  int? uid;
  String? title;
  String? videoLink;

  VideoModel({
    this.id,
    this.uid,
    this.title,
    this.videoLink,
  });

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    title = json['title'];
    videoLink = json['video_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['title'] = title;
    data['video_link'] = videoLink;
    return data;
  }
}