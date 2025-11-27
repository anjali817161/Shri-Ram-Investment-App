import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/bankdetails/view/bank_details.dart';
import 'package:shreeram_investment_app/modules/home/view/home_view.dart' as home_view;
import 'package:shreeram_investment_app/modules/portfolio/view/portfolio_view.dart';
import 'package:shreeram_investment_app/modules/profile/view/profile_view.dart';

class NavBarController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.offAll(() => home_view.InvestmentHomeScreen());
        break;
      case 1:
        Get.off(() => PortfolioView());
        break;
      case 2:
        Get.off(() => BankDetailsPage());
        break;
      case 3:
        Get.off(() => ProfilePage());
        break;
    }
  }
}
