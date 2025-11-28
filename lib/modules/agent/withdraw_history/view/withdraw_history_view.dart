import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/withdraw_history/controller/withdraw_history_controller.dart';
import 'package:intl/intl.dart';

class WithdrawHistoryView extends StatelessWidget {
  final String agentId;

  WithdrawHistoryView({super.key, required this.agentId});

  final WithdrawController controller = Get.put(WithdrawController());

  @override
  Widget build(BuildContext context) {
    controller.fetchWithdrawHistory(agentId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Withdrawal History"),
        backgroundColor: Colors.black,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.withdrawList.isEmpty) {
          return Center(child: Text("No withdrawal history found"));
        }

        return ListView.builder(
          itemCount: controller.withdrawList.length,
          padding: EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final w = controller.withdrawList[index];

            return Card(
              elevation: 2,
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Row(
                  children: [
                    Text(
                      "₹${w.amount}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
 _buildStatusChip(w.status),
                  ],
                ),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6),
                    Text("Request Date: ${DateFormat('dd MMM yyyy').format(w.createdAt)}"),
                    Text("Updated On: ${DateFormat('dd MMM yyyy').format(w.updatedAt)}"),
                    SizedBox(height: 6),
                    
                   
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    if (status == "approved") color = Colors.green;
    else if (status == "rejected") color = Colors.red;
    else color = Colors.orange;

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
