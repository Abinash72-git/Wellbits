class BaseModel {
  final bool status;
  final String message;
  final Map<String, dynamic>? fullBody;

  BaseModel({
    required this.status,
    required this.message,
    this.fullBody,
  });

  factory BaseModel.fromMap(Map<String, dynamic> map) {
    return BaseModel(
      status: map["success"] ?? false,
      message: map["message"] ?? "Unknown error",
      fullBody: map,
    );
  }
}
