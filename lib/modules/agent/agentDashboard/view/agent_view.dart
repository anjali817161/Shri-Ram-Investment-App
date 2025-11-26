import 'package:flutter/material.dart';

class AgentDashboardView extends StatefulWidget {
  const AgentDashboardView({super.key});

  @override
  State<AgentDashboardView> createState() => _AgentDashboardViewState();
}

class _AgentDashboardViewState extends State<AgentDashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();
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
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 13,
              ),
            ),
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

  Widget buildActivityCard({
    required String client,
    required String policy,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            client,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            policy,
            style:
                TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style:
                TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
          ),
          const SizedBox(height: 10),

          // status tag
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          "Agent Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- TOP CARDS ----
            Row(
              children: [
                Expanded(
                  child: buildInfoCard("Total Clients", "12"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildInfoCard("Active Policies", "5"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: buildInfoCard(
                    "Earnings",
                    "₹15400",
                    valueColor: Colors.greenAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildInfoCard("Performance", "87%"),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // -------- Recent Activities --------
            const Text(
              "Recent Activities",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            buildActivityCard(
              client: "Amit Sharma",
              policy: "Life Secure Plus",
              date: "2025-11-05",
              status: "Active",
              statusColor: Colors.greenAccent,
            ),

            const SizedBox(height: 10),
            const Divider(color: Colors.white24, thickness: 0.5),
            const SizedBox(height: 10),

            buildActivityCard(
              client: "Neha Patel",
              policy: "Health Shield",
              date: "2025-11-04",
              status: "Pending",
              statusColor: Colors.orange,
            ),

            const SizedBox(height: 30),

            // -------- Profile Summary --------
            const Text(
              "Agent Profile Summary",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "Loading agent data...",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
