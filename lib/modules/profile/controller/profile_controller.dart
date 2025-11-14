import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/profile/widgets/documents_page.dart';
import 'package:shreeram_investment_app/modules/profile/widgets/general_details.dart';

class ProfileController extends GetxController {
  RxString name = 'Anjali chaudhary'.obs;
  RxString phone = '+91 9876543210'.obs;
  RxString email = 'chaudharyanjali6300@gmail.com'.obs;
  RxBool isEditingName = false.obs;
  RxBool isEditingPhone = false.obs;
  RxBool isEditingEmail = false.obs;

  void onEditName() {
    isEditingName.value = true;
  }

  void onEditPhone() {
    isEditingPhone.value = true;
  }

  void onEditEmail() {
    isEditingEmail.value = true;
  }

  void saveAll() {
    isEditingName.value = false;
    isEditingPhone.value = false;
    isEditingEmail.value = false;
    Get.snackbar('Saved', 'Details updated successfully');
  }

  bool get isAnyEditing => isEditingName.value || isEditingPhone.value || isEditingEmail.value;

  void completeKYC() {
    Get.snackbar('KYC', 'Redirecting to KYC completion...');
  }

  void openGeneralDetails() {
    Get.to(() => const GeneralDetailsPage());
  }

  void openReports() {
   Get.to(() =>  DocumentsPage());
  }

  void openDematDetails() {
    Get.snackbar('Navigation', 'Opening Bond Demat Details...');
  }

  void openBankDetails() {
    Get.snackbar('Navigation', 'Opening Bond Bank Details...');
  }

  void openSecurity() {
    Get.snackbar('Navigation', 'Opening Security Settings...');
  }

  void openAbout() {
    Get.snackbar('Navigation', 'Opening About Page...');
  }
}
