import 'package:get/get.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';

class AgentDashboardController extends GetxController {
  RxBool isLoading = false.obs;

  RxInt totalInvestments = 0.obs;
  RxInt totalAmount = 0.obs;
  RxInt totalClients = 0.obs;
  RxInt totalCommission = 0.obs;
  RxInt avgInvestment = 0.obs;

  RxList recentInvestments = [].obs;

  String? agentId; // Store agentId for withdrawal

  Future<void> fetchDashboard(String agentId) async {
    this.agentId = agentId; // Store agentId
    isLoading.value = true;

    final response = await AuthRepository.getAgentDashboard(agentId);
    isLoading.value = false;

    print("📥 DASHBOARD API RESPONSE => $response");

    if (response["statusCode"] == 200 && response["data"]["success"] == true) {
      final dash = response["data"]["dashboard"];

      totalInvestments.value = dash["totalInvestments"] ?? 0;
      totalAmount.value = dash["totalAmount"] ?? 0;
      totalClients.value = dash["totalClients"] ?? 0;
      totalCommission.value = dash["totalCommission"] ?? 0;
      avgInvestment.value = dash["avgInvestment"] ?? 0;

      recentInvestments.value = dash["recentInvestments"] ?? [];
      update();
    } else {
      Get.snackbar("Error", "Failed to load dashboard");
    }
  }

  Future<void> withdrawAmount(int amount) async {
    if (agentId == null) {
      Get.snackbar("Error", "Agent ID not found");
      return;
    }

    final body = {
      "agentId": agentId,
      "amount": amount,
    };

    final response = await AuthRepository.AgentWithdraw(body);

    print("💰 WITHDRAW API RESPONSE => $response");

    if (response["statusCode"] == 200 || response["statusCode"] == 201) {
      final data = response["data"];
      if (data["success"] == true) {
        Get.snackbar("Success", data["message"] ?? "Withdrawal request submitted");
        // Refresh dashboard to update commission
        await fetchDashboard(agentId!);
      } else {
        Get.snackbar("Error", data["message"] ?? "Withdrawal failed");
      }
    } else {
      Get.snackbar("Error", "Withdrawal request failed");
    }
  }
}
