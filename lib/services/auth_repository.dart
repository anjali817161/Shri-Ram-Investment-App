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

  // 🔹 Verify Email OTP
  Future<Map<String, dynamic>> verifyEmailOtp(String otp, String userId) async {
    print("${ApiEndpoints.baseUrl}${ApiEndpoints.emailOtpVerify}");
    final url = Uri.parse("${ApiEndpoints.baseUrl}${ApiEndpoints.emailOtpVerify}");

    final token = await SharedPrefs.getToken() ?? "";
   

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "userId": userId,
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

  // 🔹 SUBMIT BASIC DETAILS
  Future<http.Response> submitBasicDetails({
    required String maritalStatus,
    required String occupation,
    required String annualIncome,
    required String investmentExperience,
    required String parentName,
    required bool declarationsAccepted,
  }) async {
    final token = await SharedPrefs.getToken();

    final url = Uri.parse("${ApiEndpoints.baseUrl}${ApiEndpoints.baiscDetails}");

    return await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "maritalStatus": maritalStatus,
        "occupation": occupation,
        "annualIncome": annualIncome,
        "investmentExperience": investmentExperience,
        "parentName": parentName,
        "declarationsAccepted": declarationsAccepted,
      }),
    );
  }

/// 🔹 Create MPIN API Call
  Future<Map<String, dynamic>> createMpin(String userId, String mpin) async {
    final String token = await SharedPrefs.getToken() ?? "";

    print("🔹 Constructing MPIN API URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.createMpin}");
    final uri = Uri.parse("${ApiEndpoints.baseUrl}${ApiEndpoints.createMpin}");

    print("🔹 MPIN API Request:");
    print("🔹 URL: $uri");
    print("🔹 Headers: Content-Type: application/json, Authorization: Bearer ${token != null ? 'Present' : 'Null'}");
    print("🔹 Body: {userId: $userId, mpin: $mpin}");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "userId": userId,
        "mpin": mpin,
      }),
    );

    print("🔹 MPIN API Response:");
    print("🔹 Status Code: ${response.statusCode}");
    print("🔹 Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // success
    } else {
      try {
        final errorData = jsonDecode(response.body);
        return {
          "error": true,
          "message": errorData["message"] ?? errorData["error"] ?? "Something went wrong"
        };
      } catch (e) {
        return {
          "error": true,
          "message": "Something went wrong"
        };
      }
    }
  }
}
