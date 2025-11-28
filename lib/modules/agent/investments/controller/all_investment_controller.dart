import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/investments/model/all_investment_model.dart';
import 'package:shreeram_investment_app/modules/agent/profile/controller/agent_profile_controller.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';
import 'package:shreeram_investment_app/services/api_endpoints.dart';

class AgentInvestmentController extends GetxController {
  RxList<AgentInvestment> investments = <AgentInvestment>[].obs;
  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool actionLoading = false.obs;

  late String token;
  late String agentId;
  final String baseUrl = ApiEndpoints.agentBaseUrl;

  @override
  void onInit() {
    super.onInit();

    /// 🔹 Load token from SharedPrefs
    token = SharedPrefs.getAgentToken() ?? "";
    print("🔑 AGENT TOKEN: $token");

    /// 🔹 Get agentId from profile controller
    final profileController = Get.find<AgentProfileController>();
    agentId = profileController.agent.value?.email ?? "";
    print("👤 AGENT ID: $agentId");

    if (agentId.isNotEmpty) {
      fetchInvestments(1);
    } else {
      print("⚠️ Agent ID not found, waiting for profile...");
      // Wait for profile to load
      ever(profileController.agent, (agent) {
        if (agent != null && agent.email != null) {
          agentId = agent.email!;
          print("👤 AGENT ID updated: $agentId");
          fetchInvestments(1);
        }
      });
    }
  }

  Future<void> fetchInvestments(int newPage) async {
    try {
      isLoading.value = true;
      page.value = newPage;

      print("📡 FETCHING INVESTMENTS: agentId=$agentId, page=$newPage");

      final data = await AuthRepository.fetchInvestments(
        agentId: agentId,
        token: token,
        page: newPage,
      );

      print("📥 INVESTMENTS API RESPONSE STATUS: ${data["statusCode"]}");
      print("📥 INVESTMENTS API RESPONSE: $data");

      final List items = data["investments"] ?? [];
      investments.value =
          items.map((e) => AgentInvestment.fromJson(e)).toList();

      print("✅ INVESTMENTS LOADED: ${investments.length} items");
    } catch (e) {
      print("❌ Error fetching investments: $e");
      Get.snackbar("Error", "Failed to load investments");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> doAction(String id, String action) async {
    try {
      actionLoading.value = true;

      print("🔄 PERFORMING ACTION: $action on $id");

      final res = await AuthRepository.performAction(
        id: id,
        action: action,
        token: token,
      );

      print("📥 ACTION RESPONSE: $res");

      if (res["success"] == true) {
        fetchInvestments(page.value);
        Get.snackbar("Success", "Action completed");
      } else {
        Get.snackbar("Error", res["message"] ?? "Action failed");
      }
    } catch (e) {
      print("❌ Error performing action: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      actionLoading.value = false;
    }
  }
}
