class UrlPath {
  static const LoginUrl loginUrl = LoginUrl();
}

class LoginUrl {
  const LoginUrl();
  final String sendOTP = 'farmsSentOtp';
  final String otpVerify = 'farmsVerifyOtp';
  final String createProfile = 'addUserProfile';
  final String createMedicalProfile = 'wellbitsSetMedicalProfile';
  final String userProfile = 'user_profile';
}