import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/profile/model/profile_model.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';

class ProfileController extends GetxController {
  Rx<UserData?> user = Rx<UserData?>(null);

  RxBool isEditingName = false.obs;
  RxBool isEditingEmail = false.obs;
  RxBool isEditingPhone = false.obs;

  RxBool isLoading = false.obs;

  RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// ---------------- FETCH PROFILE ---------------
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await AuthRepository().fetchUserProfile();

      print("Fetch Profile Response: ${response.statusCode} - ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user.value = UserData.fromJson(data["user"]);
        isLoading.value = false;
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", "Something went wrong");
      });
    }
  }

  /// ---------------- UPDATE PROFILE ---------------
  Future<void> updateSingleField(String key, String value) async {
    isSaving.value = true;

    final Map<String, dynamic> body = {key: value};

    try {
      isLoading.value = true;
      final response = await AuthRepository().updateProfile(body);

      print("Update Profile Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar("Success", "Profile updated successfully");
        });

        // refresh profile
        await fetchProfile();
        isLoading.value = false;
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar("Error", "Update failed");
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", "Something went wrong");
      });
    } finally {
      isSaving.value = false;
      disableEditing();
    }
  }

  // ------------ EDIT STATES -----------
  void editName() {
    disableEditing();
    isEditingName.value = true;
  }

  void editEmail() {
    disableEditing();
    isEditingEmail.value = true;
  }

  void editPhone() {
    disableEditing();
    isEditingPhone.value = true;
  }

  void disableEditing() {
    isEditingName.value = false;
    isEditingEmail.value = false;
    isEditingPhone.value = false;
  }
}
