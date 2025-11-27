// lib/modules/agent/profile/controller/agent_profile_controller.dart

import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/profile/model/agent_profile_model.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';

class AgentProfileController extends GetxController {
  Rx<AgentProfileModel?> agent = Rx<AgentProfileModel?>(null);
  RxBool loading = true.obs;
  RxBool editing = false.obs;

  // Editable fields
  RxString name = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString address = "".obs;
  RxString gender = "".obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  void prefillFields() {
  name.value = agent.value?.name ?? "";
  email.value = agent.value?.email ?? "";
  phone.value = agent.value?.phone ?? "";
  gender.value = agent.value?.gender ?? "";
  address.value = agent.value?.address ?? "";
}


  /// FETCH AGENT PROFILE
  Future<void> fetchProfile() async {
    try {
      loading.value = true;
      final data = await AuthRepository.fetchAgentProfile();
      agent.value = data;
      prefillFields();

      // name.value = data?.name ?? "";
      // email.value = data?.email ?? "";
      // phone.value = data?.phone ?? "";
      // address.value = data?.address ?? "";
      // gender.value = data?.gender ?? "";
    } catch (e) {
      Get.snackbar("Error", "Unable to load profile");
    } finally {
      loading.value = false;
    }
  }

  void toggleEditMode() {
  editing.value = !editing.value;

  if (editing.value) {
    prefillFields();
  }
}


  /// UPDATE PROFILE
  Future<void> updateProfile() async {
    try {
      loading.value = true;

      final body = {
        "name": name.value,
        "email": email.value,
        "phone": phone.value,
        "address": address.value,
        "gender": gender.value,
      };

      final updatedData = await AuthRepository.updateAgentProfile(body);
      agent.value = updatedData!;
      editing.value = false;

      Get.snackbar("Success", "Profile Updated Successfully!");
    } catch (e) {
      Get.snackbar("Error", "Update Failed");
    } finally {
      loading.value = false;
    }
  }
}
