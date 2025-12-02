import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/agentDashboard/controller/agent_dashboard_controller.dart';
import 'package:shreeram_investment_app/modules/agent/drawer/agent_drawer.dart';
import 'package:intl/intl.dart';
import 'package:shreeram_investment_app/services/api_endpoints.dart';

class AgentDashboardView extends StatefulWidget {
  final String userId;
  const AgentDashboardView({super.key, required this.userId});

  @override
  State<AgentDashboardView> createState() => _AgentDashboardViewState();
}

class _AgentDashboardViewState extends State<AgentDashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AgentDashboardController dashboardController;

  @override
  void initState() {
    super.initState();

    dashboardController = Get.put(AgentDashboardController());

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutBack));
    _animController.forward();

    dashboardController.fetchDashboard(widget.userId);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget buildInfoCard(String title, String value, {Color? valueColor}) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.75), fontSize: 13)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// IMPROVED ACTIVITY CARD
  Widget buildActivityCard(Map item) {
    String date = item["createdAt"] ?? "";
    final formattedDate = date.isNotEmpty
        ? DateFormat("dd MMM yyyy").format(DateTime.parse(date))
        : "N/A";

    String status = item["status"] ?? "N/A";
    Color statusColor = status == "active" ? Colors.greenAccent : status == "pending" ? Colors.orangeAccent : Colors.redAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SIDE
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Client ID: ${item['user']}",
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Date: $formattedDate",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // RIGHT SIDE
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${item['investedAmount']}",
                  style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // GestureDetector(
                //   onTap: () => _showImagePreview(item['image']),
                //   child: Container(
                //     width: 40,
                //     height: 40,
                //     decoration: const BoxDecoration(
                //       color: Colors.black,
                //       shape: BoxShape.circle,
                //     ),
                //     child: const Icon(
                //       Icons.visibility,
                //       color: Colors.white,
                //       size: 20,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(String imageUrl) {
    if (imageUrl.isEmpty) {
      Get.snackbar("Error", "No image available");
      return;
    }

    // Construct full URL: base domain + image path
    String baseDomain = "https://shriraminvestment-app.onrender.com";
    String fullUrl = "$baseDomain$imageUrl";

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Investment Proof",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Image.network(
                fullUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 100,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF121212),
      endDrawer: AgentDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text("Agent Dashboard", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          )
        ],
      ),

      body: Obx(() {
        if (dashboardController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

  return RefreshIndicator(
    onRefresh: () async {
      await dashboardController.fetchDashboard(widget.userId);
    },
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// TOP CARDS
          Row(
            children: [
              Expanded(
                child: buildInfoCard(
                  "Total Amount",
                  "₹${dashboardController.totalAmount.value}",
                  valueColor: Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildInfoCard(
                    "Total Investments",
                    dashboardController.totalInvestments.value.toString()),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: buildInfoCard(
                    "Total Clients",
                    dashboardController.totalClients.value.toString()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildInfoCard(
                    "Avg Investment",
                    "₹${dashboardController.avgInvestment.value}"),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// FULL-WIDTH COMMISSION CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// LEFT SIDE
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Commission",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.75), fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "₹${dashboardController.totalCommission.value}",
                      style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ],
                ),

                /// RIGHT SIDE BUTTON
                ElevatedButton(
                  onPressed: () {
                    showWithdrawBottomSheet(
                      context: context,
                      commissionAmount: dashboardController.totalCommission.value,
                      onSubmit: (amount) {
                        // Handle withdrawal submission
                        dashboardController.withdrawAmount(amount);
                      },
                      onCancelWithdrawal: () {
                        print("Withdrawal Cancelled");
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Withdraw",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Recent Activities",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          if (dashboardController.recentInvestments.isEmpty)
            const Text(
              "No recent investments",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),

          ...dashboardController.recentInvestments
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: buildActivityCard(e),
                  ))
              .toList(),

          const SizedBox(height: 50),
        ],
      ),
    ),
  );
      }),
    );
  }
  void showWithdrawBottomSheet({
  required BuildContext context,
  required int commissionAmount, // available balance
  required Function(int amount) onSubmit,
  required VoidCallback onCancelWithdrawal,
}) {
  TextEditingController amountController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Title
            Text(
              "Withdraw Amount",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            /// Amount TextField
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Amount",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final enteredText = amountController.text.trim();

                  if (enteredText.isEmpty) {
                    Get.snackbar("Error", "Please enter an amount");
                    return;
                  }

                  int enteredAmount = int.tryParse(enteredText) ?? 0;

                  if (enteredAmount <= 0) {
                    Get.snackbar("Error", "Enter a valid amount");
                    return;
                  }

                  if (enteredAmount > commissionAmount) {
                    Get.snackbar(
                      "Insufficient Balance",
                      "You don't have sufficient balance to withdraw!",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  Navigator.pop(context); // close sheet
                  onSubmit(enteredAmount); // callback
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Submit Withdrawal",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 12),

            /// Cancel Withdrawal Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onCancelWithdrawal();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Cancel Withdrawal",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

}
