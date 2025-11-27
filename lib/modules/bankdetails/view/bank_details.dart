import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeram_investment_app/modules/bankdetails/controller/bankdetails_controller.dart';
import 'package:shreeram_investment_app/modules/bankdetails/view/capture_image.dart';
import 'package:shreeram_investment_app/modules/navbar/bottom_navbar.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  @override
  State<BankDetailsPage> createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  final BankdetailsController bankController = Get.put(BankdetailsController());

  @override
  void initState() {
    super.initState();
    _loadSavedBankDetails();
  }

  /// Fetch saved bank details from local storage
  Future<void> _loadSavedBankDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ifscController.text = prefs.getString("ifsc") ?? "";
    _accountController.text = prefs.getString("accountNumber") ?? "";
    setState(() {});
  }

  /// Save bank details locally
  Future<void> _saveBankDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ifsc = _ifscController.text.trim();
    String accountNumber = _accountController.text.trim();

    await prefs.setString("ifsc", ifsc);
    await prefs.setString("accountNumber", accountNumber);

    // Debug prints
    print("IFSC: $ifsc");
    print("Account Number: $accountNumber");

    // Verify saved data
    String? savedIfsc = prefs.getString("ifsc");
    String? savedAccount = prefs.getString("accountNumber");
    print("Verification - Saved IFSC: $savedIfsc");
    print("Verification - Saved Account: $savedAccount");
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String ifsc = _ifscController.text.trim();
      String account = _accountController.text.trim();

      bool success = await bankController.submitBankInfo(account, ifsc);

      if (success) {
        await _saveBankDetails();

        Get.snackbar(
          "Success",
          "Bank details submitted successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );

        Get.to(() => const CaptureImagePage());
      }
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
      bottomNavigationBar: const BottomNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Please ensure the bank account belongs to you.\nInvestments can only be made with this account.",
                style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 24),
              const Text(
                "ENTER BANK DETAILS",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
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
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter IFSC code";
                  }
                  if (!RegExp(r"^[A-Z]{4}0[A-Z0-9]{6}$").hasMatch(value)) {
                    return "Enter valid IFSC (e.g. SBIN0005943)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter account number";
                  }
                  if (!RegExp(r"^[0-9]{9,18}$").hasMatch(value)) {
                    return "Enter valid account number (9 to 18 digits)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "To verify your account, please transfer ₹1.\nWe will refund within 48 hours.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              const Spacer(),
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
