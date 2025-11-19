import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/auth/basic_details/view/basic_details.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';
import 'package:shreeram_investment_app/modules/home/view/home_view.dart' as home_view;

class MpinController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  RxBool isLoading = false.obs;

  /// 🔹 Create MPIN Method
  Future<void> createMpin(String mpin) async {
    try {
      isLoading.value = true;

      print("🔹 Starting MPIN creation process...");

      String? userId = await SharedPrefs.getUserId();
      String? token = await SharedPrefs.getToken();

      print("🔹 User ID: $userId");
      print("🔹 Token: ${token != null ? 'Present' : 'Null'}");

      if (userId == null) {
        print("❌ User ID not found");
        Get.snackbar("Error", "User ID not found");
        return;
      }

      if (token == null) {
        print("❌ Token not found");
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      print("🔹 Calling repository createMpin with userId: $userId, mpin: $mpin");
      final res = await _repo.createMpin(userId, mpin);

      print("🔹 Repository response: $res");

      if (res["error"] == true) {
        print("❌ Error in response: ${res["message"]}");
        Get.snackbar("Error", res["message"] ?? "Failed to create MPIN");
        return;
      }

      print("✅ MPIN created successfully!");
      Get.snackbar("Success", "MPIN created successfully!");

      // Navigate to Home
      Get.offAll(() => UserBasicDetailsPage());
    } catch (e) {
      print("❌ Exception in createMpin: $e");
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Login with MPIN Method
  Future<void> loginWithMpin(String mpin) async {
    try {
      isLoading.value = true;

      print("🔹 Starting MPIN login process...");

      String? userId = await SharedPrefs.getUserId();
      String? token = await SharedPrefs.getToken();

      print("🔹 User ID: $userId");
      print("🔹 Token: ${token != null ? 'Present' : 'Null'}");

      if (userId == null) {
        print("❌ User ID not found");
        Get.snackbar("Error", "User ID not found");
        return;
      }

      if (token == null) {
        print("❌ Token not found");
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      print("🔹 Calling repository loginWithMpin with userId: $userId, mpin: $mpin");
      final res = await _repo.loginWithMpin(userId, mpin);

      print("🔹 Repository response: $res");

      if (res["error"] == true) {
        print("❌ Error in response: ${res["message"]}");
        Get.snackbar("Error", res["message"] ?? "Failed to login with MPIN");
        return;
      }

      print("✅ MPIN login successful!");
      Get.snackbar("Success", "Login successful!");

      // Navigate to Home
      Get.offAll(() => home_view.InvestmentHomeScreen());
    } catch (e) {
      print("❌ Exception in loginWithMpin: $e");
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
