import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';
import '../widgets/pdf_generator.dart';

class DocumentController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> generateCertificatePdf() async {
    print("🔄 Starting PDF generation process...");
    isLoading.value = true;

    try {
      print("🔑 Fetching token and userId...");
      final token = await SharedPrefs.getToken();
      final userId = await SharedPrefs.getUserId();

      print("📋 Token: ${token != null ? 'Present' : 'Null'}");
      print("👤 UserId: $userId");

      if (token == null || userId == null) {
        print("❌ Authentication failed - token or userId is null");
        Get.snackbar("Error", "User not authenticated. Please log in again.");
        return;
      }

      print("🌐 Making API call to fetch investment report...");
      // Fetch investment report data from API
      final response = await http.get(
        Uri.parse("https://shriraminvestment-app.onrender.com/api/investments/report/$userId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("📡 API Response Status: ${response.statusCode}");
      print("📄 API Response Content-Type: ${response.headers['content-type']}");
      print("📄 API Response Body Length: ${response.bodyBytes.length}");

      if (response.statusCode == 404) {
        print("⚠️ No investments found for user");
        print("📄 Response body: ${response.body}");
        Get.snackbar("No Investments", "You don't have any investments yet. Please make an investment first to generate a report.");
        return;
      }

      if (response.statusCode != 200) {
        print("❌ API call failed with status: ${response.statusCode}");
        print("❌ Response body: ${response.body}");
        Get.snackbar("Error", "Error generating investment report. Please try again later.");
        return;
      }

      final contentType = response.headers['content-type'] ?? '';

      if (contentType.contains('application/pdf')) {
        // The response is a PDF file, save and open it directly
        final dir = await getTemporaryDirectory();
        final filePath = '${dir.path}/fd_certificate_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print("✅ PDF file saved at: $filePath");
        await OpenFile.open(file.path);
        Get.snackbar("Success", "Investment report PDF downloaded successfully!");
      } else if (contentType.contains('application/json')) {
        print("✅ API call successful, parsing JSON response...");
        // Parse the response data as JSON
        final data = json.decode(response.body);
        print("📊 Parsed data keys: ${data.keys.toList()}");

        final investments = data['investments'] ?? [];
        print("📈 Number of investments found: ${investments.length}");

        if (investments.isEmpty) {
          print("⚠️ No investment data available");
          Get.snackbar("Info", "No investment data available.");
          return;
        }

        // For simplicity, generate PDF for the first investment
        final investment = investments[0];
        print("🎯 Processing first investment: ${investment['investmentId'] ?? 'Unknown'}");

        print("📄 Generating PDF with dynamic data...");
        await PdfGenerator.generateFDcertificate(
          customerName: investment['customerName'] ?? 'N/A',
          email: investment['email'] ?? 'N/A',
          bankName: investment['bankName'] ?? 'N/A',
          accountNumber: investment['accountNumber'] ?? 'N/A',
          ifsc: investment['ifsc'] ?? 'N/A',
          investmentId: investment['investmentId'] ?? 'N/A',
          investedAmount: investment['investedAmount']?.toString() ?? 'N/A',
          interestRate: investment['interestRate']?.toString() ?? 'N/A',
          tenure: investment['tenure']?.toString() ?? 'N/A',
          issueDate: investment['issueDate'] ?? 'N/A',
          maturityDate: investment['maturityDate'] ?? 'N/A',
          maturityValue: investment['maturityValue']?.toString() ?? 'N/A',
        );

        print("✅ PDF generation completed successfully!");
        Get.snackbar("Success", "Investment report generated successfully!");
      } else {
        print("❌ Unsupported content-type: $contentType");
        Get.snackbar("Error", "Unsupported response format received from server.");
        return;
      }
    } catch (e) {
      print("❌ ERROR in PDF generation: $e");
      print("❌ Stack trace: ${StackTrace.current}");
      Get.snackbar("Error", "Error generating investment report. Please try again later.");
    } finally {
      print("🔄 Setting loading to false");
      isLoading.value = false;
    }
  }
}
