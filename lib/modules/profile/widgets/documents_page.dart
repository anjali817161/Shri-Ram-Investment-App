import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pdf_generator.dart';  // <-- create this file (code below)

class DocumentsPage extends StatelessWidget {
  final controller = Get.put(DocumentController());

  DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        elevation: 0,
        title: const Text(
          "Documents",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "📄 User Documents",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Click below to generate and download your Fixed Deposit Certificate.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 35),

            // Download Button
            GestureDetector(
              onTap: () => controller.generateCertificatePdf(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blueAccent,
                ),
                child: const Center(
                  child: Text(
                    "Download Bond Certificate",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DocumentController extends GetxController {
  // These values will come dynamically from API
  String customerName = "Anjali";
  String email = "chaudharyanjali6300@gmail.com";
  String bankName = "Demo Bank";
  String accountNumber = "77108100003357";
  String ifsc = "BARB0VIJEON";

  String investmentId = "6916c50a16847721d5dc0b4b";
  String amount = "2,00,000";
  String interestRate = "12% p.a.";
  String tenure = "2 years";
  String dateOfIssue = "11/14/2025";
  String maturityDate = "11/14/2027";
  String maturityValue = "2,48,000";

  Future<void> generateCertificatePdf() async {
    await PdfGenerator.generateFDcertificate(
      customerName: customerName,
      email: email,
      bankName: bankName,
      accountNumber: accountNumber,
      ifsc: ifsc,
      investmentId: investmentId,
      investedAmount: amount,
      interestRate: interestRate,
      tenure: tenure,
      issueDate: dateOfIssue,
      maturityDate: maturityDate,
      maturityValue: maturityValue,
    );
  }
}
