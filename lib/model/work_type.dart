class WorkType {
  final String status;
  final String message;
  final List<WorkTypeDetail> details;

  WorkType({
    required this.status,
    required this.message,
    required this.details,
  });

  factory WorkType.fromJson(Map<String, dynamic> json) {
    return WorkType(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      details:
          (json['details'] as List<dynamic>?)
              ?.map((e) => WorkTypeDetail.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkTypeDetail {
  final String id;
  final String workType;

  WorkTypeDetail({required this.id, required this.workType});

  factory WorkTypeDetail.fromJson(Map<String, dynamic> json) {
    return WorkTypeDetail(
      id: json['id'] ?? '',
      workType: json['work_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'work_type': workType};
  }
}
