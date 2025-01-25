class WorkStyleProfile {
  final bool success;
  final String message;
  final double? workstyleScore;
  final double? totalScore;

  WorkStyleProfile({
    required this.success,
    required this.message,
    this.workstyleScore,
    this.totalScore,
  });

  factory WorkStyleProfile.fromJson(Map<String, dynamic> json) {
    return WorkStyleProfile(
      success: json['success'] as bool,
      message: json['message'] as String,
      workstyleScore: json['workstyle_score'] != null
          ? json['workstyle_score'].toDouble()
          : null,
      totalScore:
          json['total_score'] != null ? json['total_score'].toDouble() : null,
    );
  }
}
