import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/agentDashboard/controller/agent_dashboard_controller.dart';
import 'package:shreeram_investment_app/modules/agent/drawer/agent_drawer.dart';

class AgentDashboardView extends StatefulWidget {
  final String userId; // 🔥 passed from login
  const AgentDashboardView({super.key, required this.userId});

  @override
  State<AgentDashboardView> createState() => _AgentDashboardViewState();
}

class _AgentDashboardViewState extends State<AgentDashboardView>
    with SingleTickerProviderStateMixin {

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.put(AgentDashboardController());

  @override
  void initState() {
    super.initState();

    // ANIMATIONS
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();

    // FETCH DASHBOARD DATA
    dashboardController.fetchDashboard(widget.userId);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // INFO CARDS
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

  // ACTIVITY CARD
  Widget buildActivityCard(Map item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item["name"] ?? "Unknown",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Text(
            "₹${item["amount"] ?? 0}",
            style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ],
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP CARDS
              Row(
                children: [
                  Expanded(
                    child: buildInfoCard(
                        "Total Clients",
                        dashboardController.totalClients.value.toString()
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildInfoCard(
                        "Total Investments",
                        dashboardController.totalInvestments.value.toString()
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

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
                        "Commission",
                        "₹${dashboardController.totalCommission.value}"
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              buildInfoCard(
                "Avg Investment",
                "₹${dashboardController.avgInvestment.value}",
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
                padding: const EdgeInsets.only(bottom: 10),
                child: buildActivityCard(e),
              ))
                  .toList(),

              const SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }
}
