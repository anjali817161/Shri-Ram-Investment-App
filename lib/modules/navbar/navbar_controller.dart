import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/bankdetails/view/bank_details.dart';
import 'package:shreeram_investment_app/modules/home/view/home_view.dart' as home_view;
import 'package:shreeram_investment_app/modules/portfolio/view/portfolio_view.dart';
import 'package:shreeram_investment_app/modules/profile/view/profile_view.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';

class NavBarController extends GetxController {
  var currentIndex = 0.obs;

  Future<void> changeTab(int index) async {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.offAll(() => home_view.InvestmentHomeScreen());
        break;
      case 1:
        Get.off(() => PortfolioView());
        break;
      case 2:
        String? status = await SharedPrefs.getBankVerifyStatusAsync();
        if (status == "Verified") {
          Get.snackbar("KYC Completed", "Your KYC is already completed.",
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.off(() => BankDetailsPage());
        }
        break;
      case 3:
        Get.off(() => ProfilePage());
        break;
    }
  }
}
