class ApiEndpoints {
  ApiEndpoints._(); // private constructor → prevents instantiation

  // 🔵 Base URL
  static const String baseUrl = "https://shriraminvestment-app.onrender.com/api/auth/";

  // ============================================================
  // 🔐 AUTH
  // ============================================================
  static const String login = "send-mobile-otp";
  static const String verifyMobileOtp = "verify-mobile-otp";
  static const String submitUserDetails = "submit-user-details";
  static const String otpVerify = "$baseUrl/verify-otp";

  // ============================================================
  // 👤 USER PROFILE
  // ============================================================
  static const String profile = "$baseUrl/profile";
  static const String updateProfile = "$baseUrl/update-profile";
  static const String uploadProfileImage = "$baseUrl/upload-profile-image";

  
}
