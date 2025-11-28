import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/withdraw_history/model/withdraw_history_model.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';
class WithdrawController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<WithdrawModel> withdrawList = <WithdrawModel>[].obs;

  Future<void> fetchWithdrawHistory(String agentId) async {
    isLoading.value = true;

    final response = await AuthRepository.getWithdrawHistory(agentId);

    if (response["statusCode"] == 200 && response["data"]["success"] == true) {
      List data = response["data"]["withdrawals"];

      withdrawList.value = data
          .map((json) => WithdrawModel.fromJson(json))
          .toList()
          .reversed
          .toList();
    } else {
      withdrawList.clear();
    }

    isLoading.value = false;
  }
}
