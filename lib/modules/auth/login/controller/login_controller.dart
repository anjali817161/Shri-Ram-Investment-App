import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/auth/basic_info/view/basic_info.dart';
import 'package:shreeram_investment_app/modules/auth/otp/opt_verification_screen.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';

class LoginController extends GetxController {

  final AuthRepository _authRepository = AuthRepository();

  var isLoading = false.obs;
  var phoneNumber = "".obs;

  // 🔵 SEND OTP FUNCTION
  Future<void> sendOtp(String phone) async {
    phoneNumber.value = phone; // Store the phone number
    isLoading.value = true;

    final response = await _authRepository.sendMobileOtp(phone);

    isLoading.value = false;

    if (response["success"]) {
      // OTP sent successfully
      Get.snackbar(
        "Success",
        response["message"],
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to OTP Screen
      Get.to(() => OtpVerificationScreen(
            receiver: phone,
            method: 'phone',
          ));

    } else {
      // Error message
      Get.snackbar(
        "Error",
        response["message"],
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  //verify otp
  
Future<bool> verifyOtp(String otp, String receiver, String method) async {
  try {
    isLoading.value = true;

    final userId = await SharedPrefs.getUserId();

    print("Verifying OTP → $method: $receiver, OTP: $otp");

    final res = method == "phone"
        ? await _authRepository.verifyMobileOtp(receiver, otp)
        : await _authRepository.verifyEmailOtp(otp, userId! ); 
        

    final status = res["statusCode"];
    final body = res["data"];

    print("API Response → $body");

    if(userId == null && method == "email") {
      Get.snackbar("Error", "User ID not found. Please login again.",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    // 1️⃣ Check status code
    if (status == 200) {
      final token = body["token"];
      final userId = body["userId"];
      final isRegistered = body["isRegistered"] ?? false;

      if (token != null && userId != null) {
        // Save data
        await SharedPrefs.setToken(token);
        await SharedPrefs.setUserId(userId);
        await SharedPrefs.setRegistered(isRegistered);
        await SharedPrefs.setLoggedIn(true);

        Get.snackbar("Success", "OTP Verified!",
            snackPosition: SnackPosition.BOTTOM);

        return true;
      }
    }

    // Wrong OTP / expired OTP
    Get.snackbar("Error", body["message"] ?? "Invalid OTP",
        snackPosition: SnackPosition.BOTTOM);
    return false;

  } catch (e) {
    print("Exception in verifyOtp: $e");

    Get.snackbar("Error", "Something went wrong",
        snackPosition: SnackPosition.BOTTOM);

    return false;
  } finally {
    isLoading.value = false;
  }
}


}
