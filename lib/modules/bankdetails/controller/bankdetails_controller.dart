import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/bankdetails/view/capture_image.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';

class BankdetailsController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  var isLoading = false.obs;

  // 🔹 Submit Basic Info
  Future<bool> submitBankInfo(String accountNumber, String ifscCode) async {
    try {
      isLoading.value = true;

      final userId = await SharedPrefs.getUserId();

      if (userId == null) {
        Get.snackbar("Error", "User ID not found");
        return false;
      }

      final result = await _repo.submitBankDetails( accountNumber, ifscCode);

      final status = result["status"];
      final body = result["data"];

      if (status == 200 || status == 201) {
        Get.snackbar(
          "Success",
          body["message"] ?? "Details submitted successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.to(() => CaptureImagePage());
        return true;
      } else {
        Get.snackbar(
          "Failed",
          body["message"] ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
