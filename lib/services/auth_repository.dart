import 'dart:convert';
import 'dart:io';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeram_investment_app/modules/agent/profile/model/agent_profile_model.dart';
import 'package:shreeram_investment_app/modules/portfolio/model/portfolio_model.dart';
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

  /// 🔹 Login with MPIN API Call
  Future<Map<String, dynamic>> loginWithMpin(String userId, String mpin) async {
    final String token = await SharedPrefs.getToken() ?? "";

    print("🔹 Constructing MPIN Login API URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.loginWithMpin}");
    final uri = Uri.parse("${ApiEndpoints.baseUrl}${ApiEndpoints.loginWithMpin}");

    print("🔹 MPIN Login API Request:");
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

    print("🔹 MPIN Login API Response:");
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


  Future<http.Response> fetchUserProfile() async{
    final token = await SharedPrefs.getToken()
;
final url = Uri.parse("${ApiEndpoints.baseUrl}${ApiEndpoints.profile}");
return await http.get(url,
headers: {
"Authorization":" Bearer $token",
"Content-Type": "application/json"
});

  }


  Future<http.Response> updateProfile(Map<String, dynamic> body) async {
  final url = Uri.parse("${ApiEndpoints.baseUrl}${ApiEndpoints.updateProfile}");

  try {
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await SharedPrefs.getToken()}",
      },
      body: jsonEncode(body),
    );

    return response;
  } catch (e) {
    throw Exception("Update API failed: $e");
  }
}


// 🔹 Submit User Basic Details
Future<Map<String, dynamic>> submitBankDetails(
    String accountNumber, String ifscCode) async {

  final url = Uri.parse("https://shriraminvestment-app.onrender.com/api/bankkyc/ukyc");

  final token = await SharedPrefs.getToken() ?? "";
  final userId = await SharedPrefs.getUserId() ?? "";

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "userId": userId,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode
      }),
    );


      final data = jsonDecode(response.body);

      print("👉 BANK DETAIL STATUS: ${response.statusCode}");
      print("👉 BANK RESPONSE: $data");

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


Future<Map<String, dynamic>> uploadKycDocuments({
  required String userId,
  required File aadhaarFront,
  required File aadhaarBack,
  required File panCard,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");

  final url = Uri.parse(
      "https://shriraminvestment-app.onrender.com/api/bankkyc/$userId/documents");

  print("Uploading to: $url");
  print("Token: $token");

  // Correct multipart request
  var request = http.MultipartRequest("POST", url);

  request.headers.addAll({
    "Authorization": "Bearer $token",
    // DO NOT SET Content-Type, MultipartRequest will set it automatically
  });

  // Attach files
  request.files.add(
    await http.MultipartFile.fromPath("aadhaarFront", aadhaarFront.path),
  );

  request.files.add(
    await http.MultipartFile.fromPath("aadhaarBack", aadhaarBack.path),
  );

  request.files.add(
    await http.MultipartFile.fromPath("panCard", panCard.path),
  );

  print("Files added. Sending request…");

  // Send request
  final response = await request.send();

  print("Status Code: ${response.statusCode}");

  // Convert response stream to string body
  final respStr = await response.stream.bytesToString();
  print("Response Body: $respStr");

  return {
    "statusCode": response.statusCode,
    "data": jsonDecode(respStr),
  };
}

//submit nominee details

 Future<Map<String, dynamic>> submitNomineeDetails({
  required String userId,
  required String nomineeName,
  required String relation,
  required String dob,
  required String proofType,
  required String proofDigits,
  required bool addressSame,
}) async {
  final url = Uri.parse(
      "https://shriraminvestment-app.onrender.com/api/bankkyc/addnominee");

  final token = await SharedPrefs.getToken() ?? "";

  final body = jsonEncode({
    "user_id": userId,                // ✅ FIXED
    "nomineeName": nomineeName,
    "relation": relation,
    "dateOfBirth": dob,
    "proofType": proofType,
    "proofLast4Digits": proofDigits,
    "addressSame": addressSame,
  });

  print("👉 FINAL BODY SENT: $body");

  try {
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: body,
    );

    print("👉 STATUS: ${response.statusCode}");
    print("👉 RESPONSE: ${response.body}");

    return {
      "status": response.statusCode,
      "data": jsonDecode(response.body),
    };
  } catch (e) {
    return {
      "status": 500,
      "data": {"message": "Network Error: $e"},
    };
  }
}


 // Fetch all investments for a user
  Future<Map<String, dynamic>> fetchUserInvestments({
    required String userId,
    required String token,
  }) async {
    final url = Uri.parse("https://shriraminvestment-app.onrender.com/api/investment/user/$userId");
    final res = await http.get(url, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    });
    return {
      "status": res.statusCode,
      "body": res.body,
    };
  }

  // Download generated investment PDF by investmentId (server endpoint returns blob or downloadUrl)
  // If server returns a downloadUrl JSON you should call that. Here we call an endpoint that returns the file.
  Future<File> downloadInvestmentReportBlob({
    required String investmentId,
    required String token,
  }) async {
    final url = Uri.parse("https://shriraminvestment-app.onrender.com/api/investments/generate-old-report/$investmentId");
    final resp = await http.get(url, headers: {"Authorization": "Bearer $token"});
    if (resp.statusCode != 200) {
      throw Exception("Failed to download report: ${resp.statusCode}");
    }

    final bytes = resp.bodyBytes;
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/investment_report_$investmentId.pdf");
    await file.writeAsBytes(bytes);
    return file;
  }

  // If backend returns a downloadUrl (JSON) instead, use this helper to fetch that file.
  Future<File> downloadFromUrl(String downloadUrl, String filename) async {
    final resp = await http.get(Uri.parse(downloadUrl));
    if (resp.statusCode != 200) throw Exception("Failed to download file");
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/$filename");
    await file.writeAsBytes(resp.bodyBytes);
    return file;
  }

 /// 🔹 Register API
  static Future<Map<String, dynamic>> registerAgent(Map<String, dynamic> body) async {
  final url = Uri.parse(ApiEndpoints.agentBaseUrl + ApiEndpoints.register);
  final token = await SharedPrefs.getToken() ?? "";

  print("🌐 REPOSITORY DEBUG: URL = $url");
  print("🌐 Sending JSON: ${jsonEncode(body)}");

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
        },
      
      body: jsonEncode(body),
    );
print("token ---------$token");
    print("🌐 API Status Code: ${response.statusCode}");
    print("🌐 API Raw Response: ${response.body}");

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body)
    };
  } catch (e) {
    print("❌ ERROR in registerAgent(): $e");
    return {"statusCode": 500, "error": e.toString()};
  }
}

//agent login
  static Future<Map<String, dynamic>> loginAgent(Map<String, dynamic> body) async {
  final url = Uri.parse(ApiEndpoints.agentBaseUrl + ApiEndpoints.agentLogin);

print("🌐 REPOSITORY DEBUG: URL = $url");
  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        },
      body: jsonEncode(body),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body)
    };
  } catch (e) {
    return {"statusCode": 500, "error": e.toString()};
  }
}

 /// GET AGENT PROFILE
  static Future<AgentProfileModel?> fetchAgentProfile() async {

    print(ApiEndpoints.agentBaseUrl + ApiEndpoints.agentProfile);
    final token = SharedPrefs.getAgentToken();
    final url = Uri.parse(ApiEndpoints.agentBaseUrl + ApiEndpoints.agentProfile);

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json","Authorization": "Bearer $token"},
    );
print("token ---------$token");
    print("🌐 FETCH PROFILE STATUS: ${response.statusCode}");
    print("🌐 FETCH PROFILE RESPONSE: ${response.body}");


    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonBody = jsonDecode(response.body);
      return AgentProfileModel.fromJson(jsonBody["agent"]);
    } else {
      throw Exception("Failed to fetch profile with status: ${response.statusCode}");
      
    }
    
  }
  

  /// UPDATE AGENT PROFILE
  static Future<AgentProfileModel?> updateAgentProfile(
      Map<String, dynamic> body) async {
    final token = SharedPrefs.getAgentToken();
    final url = Uri.parse(ApiEndpoints.agentBaseUrl + ApiEndpoints.editAgentProfile);

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );

    print("token ---------$token");
    print("🌐  PROFILE UPDATE STATUS: ${response.statusCode}");
    print("🌐  PROFILE UPDATE RESPONSE: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonBody = jsonDecode(response.body);
      return AgentProfileModel.fromJson(jsonBody["agent"]);
    } else {
      throw Exception("Update failed");
    }
  }

// AUTH REPOSITORY
static Future<Map<String, dynamic>> getAgentDashboard(String agentId) async {
  final url = Uri.parse("${ApiEndpoints.agentBaseUrl}dashboard/$agentId");

  final token = await SharedPrefs.getAgentToken() ?? "";
  print("🔐 Agent Token: $token");

  try {
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token.isNotEmpty) "Authorization": "Bearer $token",
      },
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  } catch (e) {
    return {"statusCode": 500, "error": e.toString()};
  }
}


//agent login
  static Future<Map<String, dynamic>> AgentWithdraw(Map<String, dynamic> body) async {
  final url = Uri.parse(ApiEndpoints.agentBaseUrl2 + ApiEndpoints.withdraw);
  final token = await SharedPrefs.getAgentToken() ?? "";

print("🌐 REPOSITORY DEBUG: URL = $url");
  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
        },
      body: jsonEncode(body),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body)
    };
  } catch (e) {
    return {"statusCode": 500, "error": e.toString()};
  }
}

static Future<Map<String, dynamic>> getWithdrawHistory(String agentId) async {
  final url = "${ApiEndpoints.agentBaseUrl2}withdraw-history/$agentId";

  try {
    final response = await http.get(Uri.parse(url));

    print("📥 Withdraw History Response: ${response.body}");

    if (response.statusCode == 200) {
      return {
        "statusCode": 200,
        "data": jsonDecode(response.body),
      };
    } else {
      return {
        "statusCode": response.statusCode,
        "data": jsonDecode(response.body),
      };
    }
  } catch (e) {
    print("❌ Withdraw History Error: $e");
    return {
      "statusCode": 500,
      "data": {"success": false, "message": "Server Error"}
    };
  }
}

static Future<Map<String, dynamic>> fetchInvestments({
    required String agentId,
    required String token,
    int page = 1,
    int limit = 10,
    String search = "",
  }) async {
    final url =
        "${ApiEndpoints.agentBaseUrl}investments/$agentId?page=$page&limit=$limit&search=$search";

    print("📡 FETCHING INVESTMENTS URL: $url");
    print("🔑 TOKEN: $token");

    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );

    print("📥 INVESTMENTS API STATUS: ${response.statusCode}");
    print("📥 INVESTMENTS API RESPONSE: ${response.body}");

    return {
      "statusCode": response.statusCode,
      ...jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> performAction({
    required String id,
    required String action,
    required String token,
  }) async {
    final url = "${ApiEndpoints.agentBaseUrl}investments/$id/$action";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(response.body);
  }


}
