class MedicalProfileResponse {
  final bool success;
  final String message;
  final double? bmi;
  final String? bmiStatus;
  final String? bpStatus;
  final String? cholStatus;
  final String? sugarStatus;
  final int? totalScore;

  MedicalProfileResponse({
    required this.success,
    required this.message,
    this.bmi,
    this.bmiStatus,
    this.bpStatus,
    this.cholStatus,
    this.sugarStatus,
    this.totalScore,
  });

  factory MedicalProfileResponse.fromMap(Map<String, dynamic> json) {
    return MedicalProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      bmi: (json['bmi'] as num?)?.toDouble(),
      bmiStatus: json['bmi_status'],
      bpStatus: json['bp_status'],
      cholStatus: json['chol_status'],
      sugarStatus: json['sugar_status'],
      totalScore: json['total_score'],
    );
  }
}
