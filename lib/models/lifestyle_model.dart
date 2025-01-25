class LifestyleModel {
  final bool success;
  final String message;
  final int? lifestyleId;
  final int? userId;
  final String? walking;
  final String? workout;
  final String? cycling;
  final String? swimming;
  final String? sports;
  final String? smoking;
  final String? drinking;
  final int? lifestyleScore;

  LifestyleModel({
    required this.success,
    required this.message,
    this.lifestyleId,
    this.userId,
    this.walking,
    this.workout,
    this.cycling,
    this.swimming,
    this.sports,
    this.smoking,
    this.drinking,
    this.lifestyleScore,
  });

  /// Factory constructor to parse a JSON map into a `LifestyleModel` instance.
  factory LifestyleModel.fromMap(Map<String, dynamic> json) {
    print("LifestyleModel JSON: $json");
    return LifestyleModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      lifestyleId: json['lifestyle_id'],
      userId: json['user_id'],
      walking: json['walking'],
      workout: json['workout'],
      cycling: json['cycling'],
      swimming: json['swimming'],
      sports: json['sports'],
      smoking: json['smoking'],
      drinking: json['drinking'],
      lifestyleScore: json['lifestyle_score'],
    );
  }
}
