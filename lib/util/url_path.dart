class UrlPath {
  static const LoginUrl loginUrl = LoginUrl();
}

class LoginUrl {
  const LoginUrl();
  final String sendOTP = 'wellbit_SendOtp';
  final String otpVerify = 'wellbit_VerifyOtp';
  final String createProfile = 'create_wellbits_Profile';
  final String createMedicalProfile = 'create_Medical_Profile';
  final String creteLifeStyleProfile = 'create_Lifestyle_Profile';
  final String userProfile = 'user_profile';
}
