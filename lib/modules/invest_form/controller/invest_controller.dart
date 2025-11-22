import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';
import 'package:shreeram_investment_app/modules/portfolio/view/portfolio_view.dart';

class InvestmentController extends GetxController {
  RxBool isLoading = false.obs;

  // Form fields
  var investedAmount = "".obs;
  var timeDuration = "".obs;
  var agentId = "".obs;
  File? proofImage;

  // Set image file
  void setProofImage(File file) {
    proofImage = file;
    update();
  }

  // ================================
  // 🔥 SUBMIT INVESTMENT DETAILS
  // ================================
  Future<void> submitInvestment() async {
    print("🔍 DEBUG: submitInvestment called");

    // Validation prints
    print("🔍 DEBUG: investedAmount: '${investedAmount.value}'");
    print("🔍 DEBUG: timeDuration: '${timeDuration.value}'");
    print("🔍 DEBUG: agentId: '${agentId.value}'");
    print("🔍 DEBUG: proofImage: ${proofImage != null ? 'Set' : 'Null'}");

    if (investedAmount.value.isEmpty ||
        timeDuration.value.isEmpty ||
        agentId.value.isEmpty ||
        proofImage == null) {
      print("🔍 DEBUG: Validation failed - some fields are empty");
      Get.snackbar("Error", "Please fill all fields and upload an image.");
      return;
    }

    print("🔍 DEBUG: Validation passed");

    try {
      isLoading.value = true;
      print("🔍 DEBUG: isLoading set to true");

      final token = await SharedPrefs.getToken() ?? "";
      final userId = await SharedPrefs.getUserId() ?? "";

      print("🔍 DEBUG: Retrieved token: ${token.isNotEmpty ? 'Present' : 'Empty'}");
      print("🔍 DEBUG: Retrieved userId: '${userId}'");

      final url = Uri.parse(
          "https://shriraminvestment-app.onrender.com/api/investment/save");

      print("🔍 DEBUG: API URL: $url");

      var request = http.MultipartRequest("POST", url);

      // 🔥 Add Fields
      request.fields["investedAmount"] = investedAmount.value;
      request.fields["timeDuration"] = timeDuration.value;
      request.fields["agentId"] = agentId.value;
      request.fields["userId"] = userId;

      print("🔍 DEBUG: Added fields to request");

      // 🔥 Add Image
      print("🔍 DEBUG: Image path: ${proofImage!.path}");
      print("🔍 DEBUG: Image filename: ${proofImage!.path.split('/').last}");

      // Ensure proper filename with extension
      String filename = proofImage!.path.split('/').last;
      if (!filename.contains('.')) {
        filename = 'image.jpg'; // Default fallback
      }

      // Determine content type based on extension
      String contentType = 'image/jpeg'; // Default
      if (filename.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (filename.toLowerCase().endsWith('.jpg') || filename.toLowerCase().endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      }

      print("🔍 DEBUG: Determined content type: $contentType");

      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          proofImage!.path,
          filename: filename,
          contentType: MediaType.parse(contentType),
        ),
      );

      print("🔍 DEBUG: Added image to request with filename: $filename and content-type: $contentType");

      // 🔥 Headers
      request.headers["Authorization"] = "Bearer $token";

      print("🔍 DEBUG: Set Authorization header");

      // 🔥 SEND REQUEST
      print("🔍 DEBUG: Sending request...");
      var streamedRes = await request.send();
      var response = await http.Response.fromStream(streamedRes);

      print("👉 STATUS: ${response.statusCode}");
      print("👉 RESPONSE: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data["success"] == true) {
        print("🔍 DEBUG: Submission successful");
        Get.snackbar("Success", "Investment submitted successfully!");

        await Future.delayed(const Duration(seconds: 1));

        Get.off(() =>  PortfolioView());
      } else {
        print("🔍 DEBUG: Submission failed - status: ${response.statusCode}, message: ${data["message"] ?? "Unknown"}");
        Get.snackbar("Failed", data["message"] ?? "Something went wrong");
      }
    } catch (e) {
      print("❌ ERROR: $e");
      Get.snackbar("Error", "Network error: $e");
    } finally {
      print("🔍 DEBUG: isLoading set to false");
      isLoading.value = false;
    }
  }
}
