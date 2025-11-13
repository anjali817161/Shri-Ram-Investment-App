import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/profile/view/profile_view.dart';

class MoreController extends GetxController {
  void openAccountDetails() {
    Get.to(() => ProfilePage());
  }

  void openFixedDeposits() {
    Get.snackbar('Navigation', 'Opening Fixed Deposits...');
  }

  void openOrders() {
    Get.snackbar('Navigation', 'Opening Orders...');
  }

  void openHelp() {
    Get.snackbar('Navigation', 'Opening Help...');
  }

  void logout() {
    Get.snackbar('Logout', 'You have been logged out');
  }
}
