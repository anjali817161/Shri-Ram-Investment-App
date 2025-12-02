import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shreeram_investment_app/modules/profile/view/profile_view.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';

class NomineeController extends GetxController {
  // Text controllers
  final nomineeNameCtrl = TextEditingController();
  final dobDDCtrl = TextEditingController();
  final dobMMCtrl = TextEditingController();
  final dobYYCtrl = TextEditingController();
  final lastDigitsCtrl = TextEditingController();

  // Dropdown and checkbox values
  String? selectedRelation;
  String? selectedProof = "Aadhaar";
  bool sameAddress = true;

  Future<void> submitNominee() async {
  // Validate fields
  if (nomineeNameCtrl.text.isEmpty ||
      selectedRelation == null ||
      dobDDCtrl.text.isEmpty ||
      dobMMCtrl.text.isEmpty ||
      dobYYCtrl.text.isEmpty ||
      lastDigitsCtrl.text.isEmpty) {
    Get.snackbar("Error", "Please fill all required fields",
        backgroundColor: Colors.redAccent, colorText: Colors.white);
    return;
  }

  String? userId = await SharedPrefs.getUserId();

  if (userId == null) {
    Get.snackbar("Error", "Please login again");
    return;
  }

  String dob = "${dobDDCtrl.text.padLeft(2, '0')}-${dobMMCtrl.text.padLeft(2, '0')}-${dobYYCtrl.text}";

  // API call
  final response = await AuthRepository().submitNomineeDetails(
    userId: userId,
    nomineeName: nomineeNameCtrl.text,
    relation: selectedRelation!,
    dob: dob,
    proofType: selectedProof!,
    proofDigits: lastDigitsCtrl.text,
    addressSame: sameAddress, 
  );

  print("Nominee Submission Status: ${response['status']}");
  print("Nominee Submission Response: ${response['body']}");

  if (response['status'] == 200 || response['status'] == 201) {
    // ✅ SAVE KYC STATUS HERE
    // await SharedPrefs.setKycStatus("completed");

    Get.snackbar("Success", "Nominee added successfully!");
    
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAll(() => ProfilePage());
    });

  } else {
    Get.snackbar("Error", "Failed to add nominee. Please try again.");
  }
}

  void goToNextScreen() {
    Get.to(() => ProfilePage());
  }

  @override
  void onClose() {
    nomineeNameCtrl.dispose();
    dobDDCtrl.dispose();
    dobMMCtrl.dispose();
    dobYYCtrl.dispose();
    lastDigitsCtrl.dispose();
    super.onClose();
  }
}
