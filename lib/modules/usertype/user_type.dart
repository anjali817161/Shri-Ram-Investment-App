import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/agent/agent_login/view/agent_login.dart';
import 'package:shreeram_investment_app/modules/auth/basic_details/view/basic_details.dart';
import 'package:shreeram_investment_app/modules/auth/login/login_screen.dart';
import 'package:shreeram_investment_app/modules/home/view/home_view.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';

class SelectUserTypeView extends StatefulWidget {
  const SelectUserTypeView({super.key});

  @override
  State<SelectUserTypeView> createState() => _SelectUserTypeViewState();
}

class _SelectUserTypeViewState extends State<SelectUserTypeView>
    with SingleTickerProviderStateMixin {
  int selected = -1;

  late AnimationController _controller;
  late Animation<double> _jumpAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _jumpAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onTap(int index) async {
    setState(() => selected = index);

    await _controller.forward();
    await _controller.reverse();

    if (index == 0) {
       final token = SharedPrefs.getToken();
  final isRegistered = SharedPrefs.getRegistered();

  if (token != null && token.isNotEmpty) {
    // User is logged in
    if (isRegistered) {
      Get.to(() =>  InvestmentHomeScreen());
    } else {
      Get.to(() =>  UserBasicDetailsPage());
    }
  } else {
    // No token → take to login
    Get.to(() => LoginScreen());
  }
    } else {
     Get.to(() => AgentLoginView());
    }
  }

  Widget buildBox({
    required String title,
    required String image,
    required int index,
  }) {
    bool isSelected = (selected == index);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: ScaleTransition(
          scale: isSelected ? _jumpAnimation : AlwaysStoppedAnimation(1.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFF1C1C1E),
              border: Border.all(
                color: isSelected ? Colors.orangeAccent : Colors.white12,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image animation
                AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: isSelected ? 1.13 : 1.0,
                  curve: Curves.easeOutBack,
                  child: Image.asset(
                    image,
                    height:150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              "Select User Type",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Choose how you want to log in",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),

            /// 🔥 BOTH CARDS IN A ROW WITH RESPONSIVE WIDTH
            Row(
              children: [
                buildBox(
                  title: "User Login",
                  image: "assets/images/user_login.png",
                  index: 0,
                ),
                buildBox(
                  title: "Agent Login",
                  image: "assets/images/agent_login.png",
                  index: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
