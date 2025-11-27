
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _prefs;

  /// ---------------------------------------------------
  /// 🔹 INIT (Call this once in main() before runApp)
  /// ---------------------------------------------------
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // =====================================================
  // 🔹 KEYS
  // =====================================================
  static const String keyToken = "token";
  static const String keyUserId = "userId";
  static const String keyIsRegistered = "isRegistered";
  static const String keyIsLoggedIn = "isLoggedIn";
  static const String keyThemeMode = "themeMode"; // dark/light
  static const String keyOnboarding = "onboardingDone";
  static const String keyAgentToken = "agent_token";

  // =====================================================
  // 🔹 TOKEN
  // =====================================================
  static Future setToken(String token) async =>
      await _prefs?.setString(keyToken, token);

  static String? getToken() => _prefs?.getString(keyToken);

  // =====================================================
  // 🔹 USER ID
  // =====================================================
  static Future setUserId(String id) async =>
      await _prefs?.setString(keyUserId, id);

  static String? getUserId() => _prefs?.getString(keyUserId);

  // =====================================================
  // 🔹 REGISTRATION STATUS
  // =====================================================
  static Future setRegistered(bool status) async =>
      await _prefs?.setBool(keyIsRegistered, status);

  static bool getRegistered() => _prefs?.getBool(keyIsRegistered) ?? false;

  // =====================================================
  // 🔹 LOGIN STATUS
  // =====================================================
  static Future setLoggedIn(bool status) async =>
      await _prefs?.setBool(keyIsLoggedIn, status);

  static bool isLoggedIn() => _prefs?.getBool(keyIsLoggedIn) ?? false;

  // =====================================================
  // 🔹 THEME MODE (dark / light)
  // =====================================================
  static Future setThemeMode(String mode) async =>
      await _prefs?.setString(keyThemeMode, mode);

  static String getThemeMode() =>
      _prefs?.getString(keyThemeMode) ?? "dark"; // default dark


//set kyc status
  static const String keyKycStatus = "kycStatus";

static Future<void> setKycStatus(String status) async {
  await _prefs?.setString(keyKycStatus, status);
}

static String? getKycStatus() {
  return _prefs?.getString(keyKycStatus);
}



static Future saveAgentToken(String token) async {
  await _prefs?.setString(keyAgentToken, token);
}

static String? getAgentToken() {
  return _prefs?.getString(keyAgentToken);
}


  // =====================================================
  // 🔹 ONBOARDING
  // =====================================================
  static Future setOnboardingDone(bool done) async =>
      await _prefs?.setBool(keyOnboarding, done);

  static bool isOnboardingDone() =>
      _prefs?.getBool(keyOnboarding) ?? false;

  // =====================================================
  // 🔹 LOGOUT (Clear all user data except theme)
  // =====================================================
  static Future logout() async {
    String theme = getThemeMode(); // keep theme
    await _prefs?.clear();
    await _prefs?.setString(keyThemeMode, theme);
  }

  // =====================================================
  // 🔹 CLEAR ALL DATA
  // =====================================================
  static Future clearAll() async => await _prefs?.clear();
}
