// --------------------------------------------------------------
// CONTROLLER
// --------------------------------------------------------------

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shreeram_investment_app/modules/auth/bank_info/model/bank_info_model.dart';

class BankInfoController extends GetxController {
  var isLoading = true.obs;
  var bankDetails = BankInfoModel().obs;

  @override
  void onInit() {
    fetchBankDetails();
    super.onInit();
  }

  Future<void> fetchBankDetails() async {
    await Future.delayed(const Duration(seconds: 1)); // API delay simulation

    bankDetails.value = BankInfoModel(
      bankName: "State Bank of India",
      accountHolderName: "Anjali Chaudhary",
      accountNumber: "XXXX XXXX 2345",
      ifsc: "SBIN0001234",
      upiId: "anjali@oksbi",
    );

    isLoading.value = false;
  }
}
