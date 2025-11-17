import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/auth/bank_info/controller/bank_info_controller.dart';

class BankInfoPage extends StatelessWidget {
  final controller = Get.put(BankInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        elevation: 0,
        title: const Text(
          "Bank Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orangeAccent),
          );
        }

        final data = controller.bankDetails.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- TOP BANK ICON BOX ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.orangeAccent.withOpacity(0.4)),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.account_balance, color: Colors.orangeAccent, size: 42),
                    SizedBox(height: 10),
                    Text(
                      "Your Bank Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ------------ DETAILS CARD ---------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    _detailTile("Bank Name", data.bankName),
                    _divider(),
                    _detailTile("Account Holder Name", data.accountHolderName),
                    _divider(),
                    _detailTile("Account Number", data.accountNumber),
                    _divider(),
                    _detailTile("IFSC Code", data.ifsc),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _detailTile(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
          ),

          // Value
          Expanded(
            flex: 6,
            child: Text(
              value ?? "--",
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 1,
      color: Colors.white12,
    );
  }
}



