import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/bankdetails/view/capture_image.dart';

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  @override
  State<BankDetailsPage> createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Success',
        'Bank details submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
      Get.to(() => CaptureImagePage());
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
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Bank verification",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Exit",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instruction text
              const Text(
                "Please ensure the bank account belongs to you.\nInvestments can only be made with this account.",
                style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 24),

              // Section heading
              const Text(
                "ENTER BANK DETAILS",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),

              // IFSC field
              TextFormField(
                controller: _ifscController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "IFSC",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return "Please enter IFSC code";
                //   }
                //   if (!RegExp(r"^[A-Z]{4}0[A-Z0-9]{6}$").hasMatch(value)) {
                //     return "Enter valid IFSC code";
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 16),

              // Account number field
              TextFormField(
                controller: _accountController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Account Number",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter account number";
                  }
                  if (value.length < 9 || value.length > 18) {
                    return "Enter valid account number";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Info text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "To verify your account, please transfer ₹1.\nWe will refund within 48 hours.",
                  style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                ),
              ),

              const Spacer(),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
