class WorkDetailsResponse {
  final String status;
  final String message;
  final List<WorkDetail> details;

  WorkDetailsResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory WorkDetailsResponse.fromJson(Map<String, dynamic> json) {
    return WorkDetailsResponse(
      status: json['status'] ?? "",
      message: json['message'] ?? "",
      details: (json['details'] as List<dynamic>?)
              ?.map((item) => WorkDetail.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "details": details.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkDetail {
  final String id;
  final String yojanaName;
  final String workName;
  final String workPrice;

  WorkDetail({
    required this.id,
    required this.yojanaName,
    required this.workName,
    required this.workPrice,
  });

  factory WorkDetail.fromJson(Map<String, dynamic> json) {
    return WorkDetail(
      id: json['id'] ?? "",
      yojanaName: json['yojana_name'] ?? "",
      workName: json['work_name'] ?? "",
      workPrice: json['work_price'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "yojana_name": yojanaName,
      "work_name": workName,
      "work_price": workPrice,
    };
  }
}
