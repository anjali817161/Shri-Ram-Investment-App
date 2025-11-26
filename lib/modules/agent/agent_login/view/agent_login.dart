import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/agent_register/controller/agent_register_controller.dart';
import 'package:shreeram_investment_app/modules/agent/agent_register/view/agent_register.dart';

class AgentLoginView extends StatefulWidget {
  const AgentLoginView({super.key});

  @override
  State<AgentLoginView> createState() => _AgentLoginViewState();
}

class _AgentLoginViewState extends State<AgentLoginView> {
  final AgentRegisterController controller = Get.put(AgentRegisterController());

  final TextEditingController userId = TextEditingController();
  final TextEditingController password = TextEditingController();
   final TextEditingController confirmPassword = TextEditingController();

  bool obscure = true;
  bool obscureConfirm = true;

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.black45,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  void login() {
    if (userId.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Error", "Please enter User ID and Password",
          colorText: Colors.white);
      return;
    }

    controller.loginAgent(
      userId: userId.text,
      password: password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                "Agent Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),

              // Card / Container
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Column(
                  children: [
                    // User ID Field
                    TextField(
                      controller: userId,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("User ID"),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextField(
                      controller: password,
                      obscureText: obscure,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("Password").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() => obscure = !obscure);
                          },
                        ),
                      ),
                    ),
                      const SizedBox(height: 16),
                     // Password Field
                    TextField(
                      controller: confirmPassword,
                      obscureText: obscureConfirm,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("Confirm Password").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirm ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() => obscureConfirm = !obscureConfirm);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    // Login Button
                    Obx(() {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              controller.isLoading.value ? null : () => login(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : const Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              RichText(
  text: TextSpan(
    text: "New here? ",
    style: TextStyle(
      color: Colors.white70,
      fontSize: 14,
    ),
    children: [
      TextSpan(
        text: "Create an account",
        style: TextStyle(
          color: Colors.orangeAccent,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()..onTap = () {
          Get.to(() => RegistrationView());
        },
      ),
    ],
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
