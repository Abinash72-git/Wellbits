class ProfileModel {
  final bool success;
  final String message;
  final String? token;

  ProfileModel({
    required this.success,
    required this.message,
    this.token,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> json) {
    return ProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }
}
