import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shreeram_investment_app/modules/nominee/view/add_nominee.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';

class KycController extends GetxController {
  Rx<File?> adharFront = Rx<File?>(null);
  Rx<File?> adharBack = Rx<File?>(null);
  Rx<File?> panCard = Rx<File?>(null);

  final ImagePicker picker = ImagePicker();
  final authRepo = AuthRepository();

  RxBool isLoading = false.obs;

  // PICK IMAGE OR PDF
  Future<void> pickAnyFile(Rx<File?> fileHolder) async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {
      fileHolder.value = File(picked.path);
    }
  }

  // SUBMIT DOCUMENTS
  Future<void> submitKyc(String userId) async {
    if (adharFront.value == null ||
        adharBack.value == null ||
        panCard.value == null) {
      Get.snackbar("Error", "Please upload all documents",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      final res = await authRepo.uploadKycDocuments(
        userId: userId,
        aadhaarFront: adharFront.value!,
        aadhaarBack: adharBack.value!,
        panCard: panCard.value!,
      );

      isLoading.value = false;

      if (res["statusCode"] == 200 || res["statusCode"] == 201) {
        // Parse response to get bankVerifyStatus
        final data = res["data"];
        final status = data["kyc"]["bankVerifyStatus"] ?? "pending";

        // SAVE KYC STATUS
        await SharedPrefs.setBankVerifyStatus(status);

        // Navigate first to avoid snackbar state issues
        Get.to(() => AddNomineeScreen());

        Get.snackbar("Success", "Documents uploaded successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Something went wrong!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Upload Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
