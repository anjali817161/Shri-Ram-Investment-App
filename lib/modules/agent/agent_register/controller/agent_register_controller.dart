// lib/modules/auth/controller/auth_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/agentDashboard/view/agent_view.dart';
import 'package:shreeram_investment_app/modules/agent/agent_login/view/agent_login.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';

class AgentRegisterController extends GetxController {
  RxBool isLoading = false.obs;

 Future<void> registerAgent({
  required String name,
  required String email,
  required String userId,
  required String phone,
  required String gender,
  required String address,
  required String password,
  required String confirmPassword,
}) async {
  print("🚀 CONTROLLER DEBUG: registerAgent() called");
  print("Body -> Name: $name, Email: $email, UserID: $userId");
  print("Phone: $phone, Gender: $gender, Address: $address");

  isLoading.value = true;

final body = {
  "name": name,
  "email": email,
  "userId": userId,            // FIXED
  "phone": phone,
  "gender": gender.toLowerCase(),
  "address": address,
  "password": password,
  "confirmPassword": confirmPassword,  // FIXED
};



  print("📤 Sending Body to API: $body");

  final response = await AuthRepository.registerAgent(body);

  print("📥 API Response: $response");

  isLoading.value = false;

  if (response["statusCode"] == 200 || response["statusCode"] == 201) {
    print("✅ CONTROLLER DEBUG: Registration successful!");
    Get.snackbar("Success", "Registration Successful!");
    Get.offAll(() => AgentLoginView());
  } else {
    print("❌ CONTROLLER DEBUG: Registration failed!");
    print("API Error Message: ${response["data"]?["message"]}");
    Get.snackbar("Error",
      response["data"]?["message"] ?? "Registration failed!",
    );
  }
}

  //login

  Future<void> loginAgent({
  required String userId,
  required String password,
  
}) async {
  isLoading.value = true;

 final body = {
  "userId": userId.trim(),  // always pass as userId
  "password": password.trim(),
};


  print("📤 Final Body Sent to API: $body");
  

  final response = await AuthRepository.loginAgent(body);
  isLoading.value = false;

print("📥 API Response: $response");
print("UserID: $userId, Password: $password");
print("Status Code: ${response["statusCode"]}");
print("Response Data: ${response["data"]}");

  if (response["statusCode"] == 200 || response["statusCode"] == 201) {
      
    final token = response["data"]["token"];   // ✅ FIXED
     final userId = response["data"]["agent"]["userId"];  

    // 🔥 Save Agent Token
    await SharedPrefs.saveAgentToken(token);

    print("🔥 AGENT TOKEN SAVED: $token");
    Get.snackbar("Success", "Login Successful",
        colorText: Colors.white);
    // Navigate to Dashboard
    Get.offAll(() => AgentDashboardView(userId: userId,));
  } else {
    Get.snackbar("Login Failed",
        response["data"]?["message"] ?? "Invalid credentials",
        colorText: Colors.white);
  }
}

}
