// lib/model/work_layer.dart
class WorkLayerResponse {
  final String status;
  final String message;
  final List<WorkLayerDetail> details;

  WorkLayerResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory WorkLayerResponse.fromJson(Map<String, dynamic> json) {
    return WorkLayerResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      details: (json['details'] as List? ?? [])
          .map((e) => WorkLayerDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WorkLayerDetail {
  final String id;
  final String layer;
  final String percent;
  final String workType; // server returns "work_type" (string)

  WorkLayerDetail({
    required this.id,
    required this.layer,
    required this.percent,
    required this.workType,
  });

  factory WorkLayerDetail.fromJson(Map<String, dynamic> json) {
    return WorkLayerDetail(
      id: json['id']?.toString() ?? '',
      layer: json['layer']?.toString() ?? '',
      percent: json['percent']?.toString() ?? '',
      workType: json['work_type']?.toString() ?? '',
    );
  }
}
