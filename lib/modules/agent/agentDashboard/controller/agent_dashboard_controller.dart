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

  Future<void> fetchDashboard(String agentId) async {
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
    } else {
      Get.snackbar("Error", "Failed to load dashboard");
    }
  }
}
