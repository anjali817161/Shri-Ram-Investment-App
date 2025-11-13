import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/more_controller.dart';

class MorePage extends StatelessWidget {
  final MoreController controller = Get.put(MoreController());

  MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.openAccountDetails,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Anjali chaudhary",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: const [
                              Text(
                                "Account Details",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_outward,
                                  color: Colors.grey, size: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "AC",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.grey, thickness: 0.2),

            // Menu items
            _buildMenuItem(
              icon: Icons.savings_outlined,
              title: "Fixed Deposits",
              onTap: controller.openFixedDeposits,
            ),
            _buildMenuItem(
              icon: Icons.receipt_long_outlined,
              title: "Orders",
              onTap: controller.openOrders,
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: "Help",
              onTap: controller.openHelp,
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: "Logout",
              onTap: controller.logout,
            ),

            const Spacer(),

            // Bottom Nav
            const BottomAppBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey.shade300),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        Divider(color: Colors.grey.shade800, thickness: 0.2),
      ],
    );
  }
}
