import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/auth/basic_info/controller/basic_info_controller.dart';
import 'package:shreeram_investment_app/modules/auth/otp/opt_verification_screen.dart';

class BasicInfoFormPage extends StatefulWidget {
  const BasicInfoFormPage({super.key});

  @override
  State<BasicInfoFormPage> createState() => _BasicInfoFormPageState();
}

class _BasicInfoFormPageState extends State<BasicInfoFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final BasicInfoController controller = Get.put(BasicInfoController());

  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.black45,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Your Details",
            style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Name",
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: buildInputDecoration("Enter your name"),
            ),
            const SizedBox(height: 20),

            const Text(
              "Email",
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              decoration: buildInputDecoration("Enter your email"),
            ),
            const SizedBox(height: 30),

            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (nameController.text.isEmpty ||
                              emailController.text.isEmpty) {
                            Get.snackbar("Error", "All fields are required",
                                snackPosition: SnackPosition.BOTTOM);
                            return;
                          }

                          // CALL API
                          bool ok = await controller.submitInfo(
                            nameController.text.trim(),
                            emailController.text.trim(),
                          );

                          if (ok) {
                            Get.to(() => OtpVerificationScreen(
                                  receiver: emailController.text,
                                  method: 'email',
                                ));
                          }
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
