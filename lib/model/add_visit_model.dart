import 'dart:convert';

class VisitResponse {
  final String status;
  final String message;
  final int formId;
  final FormDetails formDetails;

  VisitResponse({
    required this.status,
    required this.message,
    required this.formId,
    required this.formDetails,
  });

  factory VisitResponse.fromJson(Map<String, dynamic> json) {
    return VisitResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      formId: json['form_id'] ?? 0,
      formDetails: FormDetails.fromJson(json['Form Details'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "form_id": formId,
      "Form Details": formDetails.toJson(),
    };
  }
}

class FormDetails {
  final String visitedBy;
  final String workItemId;
  final String isOngoing;
  final String workTypeId;
  final String workLayerId;
  final String description;
  final String remark;
  final List<String> photo;
  final String video;

  FormDetails({
    required this.visitedBy,
    required this.workItemId,
    required this.isOngoing,
    required this.workTypeId,
    required this.workLayerId,
    required this.description,
    required this.remark,
    required this.photo,
    required this.video,
  });

  factory FormDetails.fromJson(Map<String, dynamic> json) {
    // photo string -> List<String>
    List<String> photoList = [];
    try {
      if (json['photo'] != null && json['photo'] is String) {
        photoList = (jsonDecode(json['photo']) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      }
    } catch (_) {}

    return FormDetails(
      visitedBy: json['visited_by'] ?? '',
      workItemId: json['work_item_id'] ?? '',
      isOngoing: json['is_ongoing'] ?? '',
      workTypeId: json['work_type_id'] ?? '',
      workLayerId: json['work_layer_id'] ?? '',
      description: json['description'] ?? '',
      remark: json['remark'] ?? '',
      photo: photoList,
      video: json['video'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "visited_by": visitedBy,
      "work_item_id": workItemId,
      "is_ongoing": isOngoing,
      "work_type_id": workTypeId,
      "work_layer_id": workLayerId,
      "description": description,
      "remark": remark,
      "photo": photo,
      "video": video,
    };
  }
}
