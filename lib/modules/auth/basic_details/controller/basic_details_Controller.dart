import 'dart:convert';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';

class BasicDetailsController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();

  var isLoading = false.obs;

  // 🔹 SUBMIT BASIC DETAILS METHOD
  Future<bool> submitBasicDetails({
    required String maritalStatus,
    required String occupation,
    required String annualIncome,
    required String investmentExperience,
    required String parentName,
    required bool declarationsAccepted,
  }) async {
    try {
      isLoading.value = true;

      final response = await _authRepo.submitBasicDetails(
        maritalStatus: maritalStatus,
        occupation: occupation,
        annualIncome: annualIncome,
        investmentExperience: investmentExperience,
        parentName: parentName,
        declarationsAccepted: declarationsAccepted,
      );

      final data = jsonDecode(response.body);
      print("👉 SUBMIT BASIC DETAILS RESPONSE: $data");
      print("👉 SUBMIT BASIC DETAILS STATUS: ${response.statusCode}");
      print("👉 SUBMIT BASIC DETAILS BODY: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Details Submitted Successfully");
        return true;
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Something went wrong",
        );
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
