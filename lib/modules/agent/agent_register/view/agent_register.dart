// lib/modules/auth/view/registration_view.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/agent_login/view/agent_login.dart';
import 'package:shreeram_investment_app/modules/agent/agent_register/controller/agent_register_controller.dart';
import 'package:shreeram_investment_app/modules/auth/login/login_screen.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final AgentRegisterController controller = Get.put(AgentRegisterController());

  // Controllers
  final name = TextEditingController();
  final email = TextEditingController();
  final userId = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  String gender = "Male";

  InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.black45,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void register() {
  print("🔍 DEBUG: Starting register()...");
  print("Name: '${name.text}'");
  print("Email: '${email.text}'");
  print("User ID: '${userId.text}'");
  print("Phone: '${phone.text}'");
  print("Gender: '$gender'");
  print("Address: '${address.text}'");
  print("Password: '${password.text}'");
  print("Confirm Password: '${confirmPassword.text}'");

  if (name.text.trim().isEmpty ||
      email.text.trim().isEmpty ||
      userId.text.trim().isEmpty ||
      phone.text.trim().isEmpty ||
      address.text.trim().isEmpty ||
      password.text.trim().isEmpty ||
      confirmPassword.text.trim().isEmpty) {
    print("❌ DEBUG: One or more fields are empty.");
    Get.snackbar("Error", "All fields are required");
    return;
  }

  if (password.text != confirmPassword.text) {
    print("❌ DEBUG: Password mismatch!");
    Get.snackbar("Error", "Passwords do not match");
    return;
  }

  print("✅ DEBUG: All fields valid. Calling controller...");
  controller.registerAgent(
    name: name.text.trim(),
    email: email.text.trim(),
    userId: userId.text.trim(),
    phone: phone.text.trim(),
    gender: gender,
    address: address.text.trim(),
    password: password.text.trim(),
    confirmPassword: confirmPassword.text.trim(),
    );
  
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Agent Registration"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildField("Full Name", name),
            buildField("Email", email),
            buildField("User ID", userId),
            buildField("Phone Number", phone, TextInputType.phone),

            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text("Gender", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 8),

            genderDropdown(),
            const SizedBox(height: 8),

            buildField("Address", address, TextInputType.text, 3),
            buildField("Password", password, TextInputType.text, 1, true),
            buildField("Confirm Password", confirmPassword, TextInputType.text,
                1, true),

            const SizedBox(height: 22),

            Obx(() {
              return ElevatedButton(
                onPressed:
                    controller.isLoading.value ? null : () => register(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("REGISTER",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
              );
            }),

             const SizedBox(height: 20),
             RichText(
  text: TextSpan(
    text: "Already have and account? ",
    style: TextStyle(
      color: Colors.white70,
      fontSize: 14,
    ),
    children: [
      TextSpan(
        text: "Login",
        style: TextStyle(
          color: Colors.orangeAccent,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()..onTap = () {
          Get.to(() => AgentLoginView());
        },
      ),
    ],
  ),
)

          ],
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController ctrl,
      [TextInputType? type, int maxLines = 1, bool obscure = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              style: const TextStyle(color: Colors.white),
              obscureText: obscure,
              maxLines: obscure ? 1 : maxLines,
              keyboardType: type,
              decoration: input("Enter $label"),
            ),
          ]),
    );
  }

  Widget genderDropdown() {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: gender,
          dropdownColor: Colors.black,
          iconEnabledColor: Colors.white,
          items: ["Male", "Female", "Other"]
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.white)),
                ),
              )
              .toList(),
          onChanged: (v) {
            setState(() => gender = v!);
          },
        ),
      ),
    );
  }
}
