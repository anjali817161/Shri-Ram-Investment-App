import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shreeram_investment_app/modules/auth/basic_details/view/basic_details.dart';
import 'package:shreeram_investment_app/modules/auth/basic_info/view/basic_info.dart';
import 'package:shreeram_investment_app/modules/auth/login/controller/login_controller.dart';
import 'package:shreeram_investment_app/modules/auth/mpin/set_mpin_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String receiver; // can be phone OR email
  final String method;   // "phone" or "email"

  const OtpVerificationScreen({
    super.key,
    required this.receiver,
    required this.method,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _secondsRemaining = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }


void _verifyOtp() async {
  final LoginController controller = Get.find<LoginController>();
  final otp = _otpController.text.trim();

  // 1️⃣ Validate OTP length first
  if (otp.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a valid 6-digit OTP.'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  // 2️⃣ Call API to verify OTP
  bool success = await controller.verifyOtp(otp, widget.receiver);

  // 3️⃣ Based on API response
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP Verified Successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // 4️⃣ Navigation logic after OTP verification
    if (widget.method == "phone") {
      // Phone OTP → Go to Basic Info Form
      Get.offAll(() => BasicInfoFormPage());
    } else {
      // Email OTP → Go to User Basic Details Page
      Get.off(() => UserBasicDetailsPage());
    }

  } else {
    // ❌ Wrong or expired OTP
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid OTP. Please try again.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}


  void _resendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'OTP resent to your ${widget.method == "phone" ? "mobile" : "email"}'),
        backgroundColor: Colors.green,
      ),
    );
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final pinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = pinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Enter OTP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.method == "phone"
                          ? "We've sent an OTP to your mobile ${widget.receiver}"
                          : "We've sent an OTP to your email ${widget.receiver}",
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),

                  // Edit button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Centered OTP input
              Center(
                child: Pinput(
                  controller: _otpController,
                  length: 6,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: pinTheme,
                  focusedPinTheme: focusedPinTheme,
                ),
              ),

              const SizedBox(height: 15),

              Align(
                alignment: Alignment.centerRight,
                child: _secondsRemaining > 0
                    ? Text(
                        "Resend OTP in ${_secondsRemaining}s",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      )
                    : GestureDetector(
                        onTap: _resendOtp,
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _verifyOtp,
                  child: const Text(
                    "Verify OTP",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
