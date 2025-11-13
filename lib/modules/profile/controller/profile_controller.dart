import 'package:get/get.dart';

class ProfileController extends GetxController {
  void completeKYC() {
    Get.snackbar('KYC', 'Redirecting to KYC completion...');
  }

  void openGeneralDetails() {
    Get.snackbar('Navigation', 'Opening General Details...');
  }

  void openReports() {
    Get.snackbar('Navigation', 'Opening Reports & Documents...');
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
