class MedicalProfileResponse {
  final String? medicalId;
  final int? userId;
  final double? height;
  final double? weight;
  final double? bmi;
  final String? bmiStatus;
  final int? bmiScore;
  final double? pressureSystolic;
  final double? pressureDiastolic;
  final String? bpStatus;
  final int? bpScore;
  final double? triglycerides;
  final double? ldl;
  final double? hdl;
  final String? cholesterolStatus;
  final int? cholesterolScore;
  final double? sugarPre;
  final double? sugarPost;
  final String? sugarStatus;
  final int? sugarScore;
  final int? totalScore;
  final String? status;

  MedicalProfileResponse({
    this.medicalId,
    this.userId,
    this.height,
    this.weight,
    this.bmi,
    this.bmiStatus,
    this.bmiScore,
    this.pressureSystolic,
    this.pressureDiastolic,
    this.bpStatus,
    this.bpScore,
    this.triglycerides,
    this.ldl,
    this.hdl,
    this.cholesterolStatus,
    this.cholesterolScore,
    this.sugarPre,
    this.sugarPost,
    this.sugarStatus,
    this.sugarScore,
    this.totalScore,
    this.status,
  });

  // Factory method to parse JSON
  factory MedicalProfileResponse.fromMap(Map<String, dynamic> json) {
    return MedicalProfileResponse(
      medicalId: json['medical_id'] as String?,
      userId: json['user_id'] as int?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      bmiStatus: json['bmi_status'] as String?,
      bmiScore: json['bmi_score'] as int?,
      pressureSystolic: (json['pressure_systolic'] as num?)?.toDouble(),
      pressureDiastolic: (json['pressure_diastolic'] as num?)?.toDouble(),
      bpStatus: json['bp_status'] as String?,
      bpScore: json['bp_score'] as int?,
      triglycerides: (json['triglycerides'] as num?)?.toDouble(),
      ldl: (json['ldl'] as num?)?.toDouble(),
      hdl: (json['hdl'] as num?)?.toDouble(),
      cholesterolStatus: json['cholestrol_status'] as String?,
      cholesterolScore: json['cholestrol_score'] as int?,
      sugarPre: (json['sugar_pre'] as num?)?.toDouble(),
      sugarPost: (json['sugar_post'] as num?)?.toDouble(),
      sugarStatus: json['sugar_status'] as String?,
      sugarScore: json['sugar_score'] as int?,
      totalScore: json['total_score'] as int?,
      status: json['status'] as String?,
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toMap() {
    return {
      'medical_id': medicalId,
      'user_id': userId,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'bmi_status': bmiStatus,
      'bmi_score': bmiScore,
      'pressure_systolic': pressureSystolic,
      'pressure_diastolic': pressureDiastolic,
      'bp_status': bpStatus,
      'bp_score': bpScore,
      'triglycerides': triglycerides,
      'ldl': ldl,
      'hdl': hdl,
      'cholestrol_status': cholesterolStatus,
      'cholestrol_score': cholesterolScore,
      'sugar_pre': sugarPre,
      'sugar_post': sugarPost,
      'sugar_status': sugarStatus,
      'sugar_score': sugarScore,
      'total_score': totalScore,
      'status': status,
    };
  }
}
