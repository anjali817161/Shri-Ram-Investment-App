import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/investments/controller/all_investment_controller.dart';

class AgentInvestmentsView extends StatelessWidget {
  final AgentInvestmentController controller =
      Get.put(AgentInvestmentController());

  AgentInvestmentsView({super.key, required String agentId});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return Colors.greenAccent;
      case "pending":
        return Colors.orangeAccent;
      case "rejected":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xff1A1A1A),
        title: const Text("All Investments"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.investments.length,
          itemBuilder: (context, index) {
            final inv = controller.investments[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============================
                    // HEADER
                    // ============================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          inv.userName ?? "Unknown User",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color:
                                getStatusColor(inv.status).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            inv.status.toUpperCase(),
                            style: TextStyle(
                              color: getStatusColor(inv.status),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      inv.userEmail ?? "-",
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 13),
                    ),

                    const SizedBox(height: 14),

                    // ============================
                    // DETAILS
                    // ============================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _detailTile("Amount", "₹${inv.investedAmount}"),
                        _detailTile("Duration", "${inv.timeDuration} yr"),
                        _detailTile(
                            "Verified", inv.verified ? "Yes" : "No",
                            color: inv.verified
                                ? Colors.greenAccent
                                : Colors.redAccent),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Date: ${inv.createdAt.toLocal().toString().split(' ')[0]}",
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 13),
                    ),

                    const SizedBox(height: 16),

                    // ============================
                    // BUTTONS IN A ROW
                    // ============================
                    Row(
                      children: [
                        // VERIFY
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.actionLoading.value ||
                                    inv.verified
                                ? null
                                : () => controller.doAction(inv.id, "verify"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              disabledBackgroundColor: Colors.blueGrey,
                            ),
                            child: controller.actionLoading.value
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white),
                                  )
                                : const Text("Verify"),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // APPROVE
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.actionLoading.value ||
                                    inv.status == "active"
                                ? null
                                : () => controller.doAction(inv.id, "approve"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent.shade700,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              disabledBackgroundColor:
                                  Colors.greenAccent.withOpacity(0.3),
                            ),
                            child: const Text("Approve"),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // REJECT
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.actionLoading.value ||
                                    inv.status == "rejected"
                                ? null
                                : () => controller.doAction(inv.id, "reject"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.shade700,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              disabledBackgroundColor:
                                  Colors.redAccent.withOpacity(0.3),
                            ),
                            child: const Text("Reject"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _detailTile(String title, String value, {Color color = Colors.white}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                const TextStyle(fontSize: 12, color: Colors.white54)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
