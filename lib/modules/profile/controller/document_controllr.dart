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
          "Content-Type": "application/json",
        },
      );

      print("📡 API Response Status: ${response.statusCode}");
      print("📄 API Response Body Length: ${response.body.length}");

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

      print("✅ API call successful, parsing response...");
      // Parse the response data
      final data = json.decode(response.body);
      print("📊 Parsed data keys: ${data.keys.toList()}");

      // Assuming the API returns investment details in JSON format
      // You may need to adjust based on actual API response structure
      final investments = data['investments'] ?? [];
      print("📈 Number of investments found: ${investments.length}");

      if (investments.isEmpty) {
        print("⚠️ No investment data available");
        Get.snackbar("Info", "No investment data available.");
        return;
      }

      // For simplicity, generate PDF for the first investment
      // You can modify to generate for all or specific ones
      final investment = investments[0];
      print("🎯 Processing first investment: ${investment['investmentId'] ?? 'Unknown'}");

      print("📄 Generating PDF with dynamic data...");
      // Generate PDF using the PdfGenerator class with dynamic data
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
