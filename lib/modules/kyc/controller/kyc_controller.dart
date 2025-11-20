import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';

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

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar("Success", "Documents uploaded successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);

        await Future.delayed(Duration(seconds: 1));
        Get.toNamed("/add-nominee"); // Your next screen
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
