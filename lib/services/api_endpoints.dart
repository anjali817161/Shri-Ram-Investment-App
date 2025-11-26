class ApiEndpoints {
  ApiEndpoints._(); // private constructor → prevents instantiation

  // 🔵 Base URL
  static const String baseUrl = "https://shriraminvestment-app.onrender.com/api/auth/";
  static const String agentBaseUrl = "https://shriraminvestment-app.onrender.com/api/agents/";

  // ============================================================
  // 🔐 AUTH
  // ============================================================
  static const String login = "send-mobile-otp";
  static const String verifyMobileOtp = "verify-mobile-otp";
  static const String submitUserDetails = "submit-user-details";
  static const String emailOtpVerify = "verify-email-otp";
  static const String baiscDetails = "details";
  static const String createMpin = "create-mpin";
  static const String loginWithMpin = "login-with-mpin";


    // ============================================================
  // 🔐 AGENT
  // ============================================================
  static const String register = "register";
  static const String agentLogin = "login";

  // ============================================================
  // 👤 USER PROFILE
  // ============================================================
  static const String profile = "me";
  static const String updateProfile = "update";
  static const String uploadProfileImage = "upload-profile-image";

  
}
