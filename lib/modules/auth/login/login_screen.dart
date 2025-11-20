import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shreeram_investment_app/modules/auth/login/controller/login_controller.dart';
import 'package:shreeram_investment_app/modules/auth/otp/opt_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final LoginController loginController = Get.put(LoginController());
  
  final TextEditingController _phoneController = TextEditingController();
  String completePhoneNumber = '';
  String numberOnly = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Mobile Number",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "We'll send an OTP to verify",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 25),
              IntlPhoneField(
                controller: _phoneController,
                dropdownTextStyle: const TextStyle(color: Colors.white),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                dropdownIcon:
                    const Icon(Icons.arrow_drop_down, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter mobile number',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  completePhoneNumber = phone.completeNumber;
                  numberOnly = phone.number;
                },
                validator: (phone) {
                  if (phone == null || phone.number.isEmpty) {
                    return 'Please enter your mobile number';
                  } else if (phone.number.length < 10) {
                    return 'Enter valid 10-digit number';
                  }
                  return null;
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child:ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      loginController.sendOtp(numberOnly);
    }
  },
  child: Obx(() => loginController.isLoading.value
      ? const CircularProgressIndicator(color: Colors.black)
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Get OTP",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_right_alt, color: Colors.black),
          ],
        )),
)

              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
