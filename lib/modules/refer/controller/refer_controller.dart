import 'package:get/get.dart';

class ReferController extends GetxController {
  var referAmount = 0.obs;
  int finalAmount = 25000; 

  @override
  void onInit() {
    super.onInit();
    animateAmount();
  }

  void animateAmount() async {
    for (int i = 0; i <= finalAmount; i += 400) {
      await Future.delayed(const Duration(milliseconds: 20));
      referAmount.value = i;
    }
    referAmount.value = finalAmount;
  }
}
