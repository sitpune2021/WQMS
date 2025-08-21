class WorkResponse {
  final String status;
  final String message;
  final List<WorkDetails> details;

  WorkResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory WorkResponse.fromJson(Map<String, dynamic> json) {
    final detailsData = json['details'];

    List<WorkDetails> parsedDetails = [];
    if (detailsData is List) {
      // Case: details is a list
      parsedDetails = detailsData.map((e) => WorkDetails.fromJson(e)).toList();
    } else if (detailsData is Map<String, dynamic>) {
      // Case: details is a single object
      parsedDetails = [WorkDetails.fromJson(detailsData)];
    }

    return WorkResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      details: parsedDetails,
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

class WorkDetails {
  final String id;
  final String yojanaName;
  final String workName;
  final String workPrice;
  final String assignedTo;
  final String startDate;
  final String endDate;

  WorkDetails({
    required this.id,
    required this.yojanaName,
    required this.workName,
    required this.workPrice,
    required this.assignedTo,
    required this.startDate,
    required this.endDate,
  });

  factory WorkDetails.fromJson(Map<String, dynamic> json) {
    return WorkDetails(
      id: json['id'] ?? '',
      yojanaName: json['yojana_name'] ?? '',
      workName: json['work_name'] ?? '',
      workPrice: json['work_price'] ?? '',
      assignedTo: json['assigned_to'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'yojana_name': yojanaName,
      'work_name': workName,
      'work_price': workPrice,
      'assigned_to': assignedTo,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}
