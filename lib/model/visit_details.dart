class VisitDetail {
  final String id;
  final String workItemId;
  final String isOngoing;
  final String description; // <- This must exist
  final String remark;
  final String video;
  final String isDeleted;
  final String name;
  final String date;
  final String workType;
  final String workLayer;
  final List<String> photos;

  VisitDetail({
    required this.id,
    required this.workItemId,
    required this.isOngoing,
    required this.description,
    required this.remark,
    required this.video,
    required this.isDeleted,
    required this.name,
    required this.date,
    required this.workType,
    required this.workLayer,
    required this.photos,
  });

  factory VisitDetail.fromJson(Map<String, dynamic> json) {
    return VisitDetail(
      id: json['id'] ?? '',
      workItemId: json['work_item_id'] ?? '',
      isOngoing: json['is_ongoing'] ?? '',
      description: json['description'] ?? '', // <- Make sure this exists
      remark: json['remark'] ?? '',
      video: json['video'] ?? '',
      isDeleted: json['isdeleted'] ?? '',
      name: json['user'] != null ? json['user']['name'] ?? '' : '',
      date: json['date'] ?? '',
      workType: json['work_type'] ?? '',
      workLayer: json['work_layer'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'work_item_id': workItemId,
      'is_ongoing': isOngoing,
      'description': description,
      'remark': remark,
      'video': video,
      'isdeleted': isDeleted,
      'name': name,
      'date': date,
      'work_type': workType,
      'work_layer': workLayer,
      'photos': photos,
    };
  }
}
