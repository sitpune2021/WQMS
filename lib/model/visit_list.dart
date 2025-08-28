class VisitResponse {
  final String status;
  final String message;
  final List<VisitItem> details;

  VisitResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory VisitResponse.fromJson(Map<String, dynamic> json) {
    return VisitResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      details: json['details'] != null
          ? List<VisitItem>.from(
              json['details'].map((x) => VisitItem.fromJson(x)),
            )
          : [],
    );
  }
}

class VisitItem {
  final String id;
  final String isOngoing;
  final String workName;
  final String workPrice;
  final String date;

  VisitItem({
    required this.id,
    required this.isOngoing,
    required this.workName,
    required this.workPrice,
    required this.date,
  });

  factory VisitItem.fromJson(Map<String, dynamic> json) {
    return VisitItem(
      id: json['id'] ?? '',
      isOngoing: json['is_ongoing'] ?? '',
      workName: json['work_name'] ?? '',
      workPrice: json['work_price'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
