import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shreeram_investment_app/modules/auth/basic_details/view/basic_details.dart';
import 'package:shreeram_investment_app/modules/auth/mpin/set_mpin_controller.dart';
import 'package:shreeram_investment_app/modules/home/view/home_view.dart' as home_view;

class SetMpinScreen extends StatefulWidget {
  const SetMpinScreen({super.key});

  @override
  State<SetMpinScreen> createState() => _SetMpinScreenState();
}

class _SetMpinScreenState extends State<SetMpinScreen> {
  final TextEditingController _mpinController = TextEditingController();
  final TextEditingController _confirmMpinController = TextEditingController();

  final MpinController controller = Get.put(MpinController());  

  bool _isMpinVisible = false;
  bool _isConfirmMpinVisible = false;
  bool _isTermsAccepted = false;

 void _proceed() {
  FocusScope.of(context).unfocus();

  if (!_isTermsAccepted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please accept Terms & Conditions to proceed'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  if (_mpinController.text.length != 6 ||
      _confirmMpinController.text.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a valid 6-digit PIN'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  if (_mpinController.text != _confirmMpinController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PINs do not match. Please try again.'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  controller.createMpin(_mpinController.text);
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
        child: SingleChildScrollView(
          // ✅ Makes the screen scrollable to avoid overflow
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create your secure PIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "This will allow you (and only you) to access your investments",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 50),

              // ✅ Set MPIN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Set PIN",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isMpinVisible = !_isMpinVisible;
                      });
                    },
                    icon: Icon(
                      _isMpinVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Center(
                child: Pinput(
                  controller: _mpinController,
                  length: 6,
                  obscureText: !_isMpinVisible,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: pinTheme,
                  focusedPinTheme: focusedPinTheme,
                ),
              ),

              const SizedBox(height: 35),

              // ✅ Confirm MPIN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Confirm PIN",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isConfirmMpinVisible = !_isConfirmMpinVisible;
                      });
                    },
                    icon: Icon(
                      _isConfirmMpinVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Center(
                child: Pinput(
                  controller: _confirmMpinController,
                  length: 6,
                  obscureText: !_isConfirmMpinVisible,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: pinTheme,
                  focusedPinTheme: focusedPinTheme,
                ),
              ),

              const SizedBox(height: 40),

              // ✅ Terms Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isTermsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _isTermsAccepted = value ?? false;
                      });
                    },
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "I have read and agree to the ",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms & Conditions",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            // Add link tap if needed
                            // recognizer: TapGestureRecognizer()..onTap = () {}
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 140),

              // ✅ Proceed button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _proceed,
                  icon: const Icon(Icons.lock_outline, color: Colors.black),
                  label: const Text(
                    "Proceed",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
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
