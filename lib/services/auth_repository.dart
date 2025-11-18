import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shreeram_investment_app/services/api_endpoints.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';

class AuthRepository {
  // 🔵 SEND MOBILE OTP
  Future<Map<String, dynamic>> sendMobileOtp(String phone) async {
    final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.login);

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"phone": phone}),
      );

      final data = jsonDecode(response.body);
      print("status code------------ ${response.statusCode}");
            print("body-------- ${response.body}");


      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": data["message"] ?? "OTP sent successfully",
        };
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Something went wrong",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Network error: $e",
      };
    }
    
  }

  //verify otp


  Future<Map<String, dynamic>> verifyMobileOtp(String phone, String otp) async {
  print("${ApiEndpoints.baseUrl}${ApiEndpoints.verifyMobileOtp}");
  final url = Uri.parse("${ApiEndpoints.baseUrl}${ApiEndpoints.verifyMobileOtp}");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "phone": phone,
      "otp": otp,
    }),
  );

  final data = jsonDecode(response.body);

  print("status code------------ ${response.statusCode}");
  print("body-------- ${response.body}");

  // 🔥 Return body + statusCode
  return {
    "statusCode": response.statusCode,
    "data": data,
  };
}

// 🔹 Submit User Basic Details
  Future<Map<String, dynamic>> submitBasicInfo(
      String userId, String name, String email) async {

    final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.submitUserDetails);

    final token = await SharedPrefs.getToken() ?? "";

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "userId": userId,
          "name": name,
          "email": email,
        }),
      );

      final data = jsonDecode(response.body);

      print("👉 BASIC INFO API STATUS: ${response.statusCode}");
      print("👉 BASIC INFO RESPONSE: $data");

      return {
        "status": response.statusCode,
        "data": data,
      };

    } catch (e) {
      return {
        "status": 500,
        "data": {"message": "Network Error: $e"},
      };
    }
  }


}
