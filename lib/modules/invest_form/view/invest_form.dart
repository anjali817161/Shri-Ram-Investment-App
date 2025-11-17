import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shreeram_investment_app/modules/portfolio/view/portfolio_view.dart';

// Dummy controller (Replace with your actual GetX controller)
class BankController extends GetxController {
  var accountNumber = "1234 5678 9876".obs;
  var accountHolder = "Anjali Chaudhary".obs;
  var ifsc = "HDFC0001234".obs;
  var bankName = "HDFC Bank".obs;
}

class InvestmentDetailsPage extends StatefulWidget {
  const InvestmentDetailsPage({super.key});

  @override
  State<InvestmentDetailsPage> createState() => _InvestmentDetailsPageState();
}

class _InvestmentDetailsPageState extends State<InvestmentDetailsPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController agentIdController = TextEditingController();
  final BankController bankController = Get.put(BankController());

  File? proofImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        proofImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Investment Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 10),

                _buildInputField(
                  controller: amountController,
                  hint: "Invested Amount (₹)",
                ),
                const SizedBox(height: 15),

                _buildInputField(
                  controller: durationController,
                  hint: "Time Duration (in years)",
                ),
                const SizedBox(height: 15),

                _buildInputField(
                  controller: agentIdController,
                  hint: "Agent ID",
                ),
                const SizedBox(height: 20),

                Text(
                  "Upload Investment Proof Image",
                  style: TextStyle(color: Colors.grey.shade300),
                ),

                const SizedBox(height: 8),

                // Upload Box
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white30, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.upload_file,
                            color: Colors.white70, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            proofImage == null
                                ? "Choose file (No file chosen)"
                                : proofImage!.path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ⭐⭐⭐ IMAGE PREVIEW HERE ⭐⭐⭐
                if (proofImage != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selected Image Preview",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          proofImage!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                // 🔥 Bank Details Card (unchanged)
                if (proofImage != null) _buildBankCard(),

                const SizedBox(height: 30),

                // Submit Button
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar("success", "Investment details saved successfully", backgroundColor: Colors.green);
                      Get.to(() => PortfolioView());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.black,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildBankCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bankRow("Bank Name:", bankController.bankName.value),
            _bankRow("Account Holder:", bankController.accountHolder.value),
            _bankRow("Account Number:", bankController.accountNumber.value),
            _bankRow("IFSC Code:", bankController.ifsc.value),
          ],
        ),
      ),
    );
  }

  Widget _bankRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
