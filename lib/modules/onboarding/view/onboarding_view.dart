import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/auth/basic_details/view/basic_details.dart';
import 'package:shreeram_investment_app/modules/auth/login/login_screen.dart';
import 'package:shreeram_investment_app/modules/auth/mpin/set_mpin_screen.dart';
import 'package:shreeram_investment_app/modules/home/view/home_view.dart';
import 'package:shreeram_investment_app/modules/onboarding/controller/onboarding_controller.dart';
import 'package:shreeram_investment_app/modules/usertype/user_type.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final OnboardingController controller = Get.put(OnboardingController());
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    _autoSlide();
  }

  void _autoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        int nextPage = (controller.pageIndex.value + 1) %
            controller.onboardingPages.length;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        controller.pageIndex.value = nextPage;
        _autoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) => controller.pageIndex.value = index,
                itemCount: controller.onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = controller.onboardingPages[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Image.asset(
                            page.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.onboardingPages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width:
                          controller.pageIndex.value == index ? 10 : 8,
                      height:
                          controller.pageIndex.value == index ? 10 : 8,
                      decoration: BoxDecoration(
                        color: controller.pageIndex.value == index
                            ? Colors.white
                            : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (){
                  Get.offAll(() => SelectUserTypeView());
                },
//                onPressed: () {
//   final token = SharedPrefs.getToken();
//   final isRegistered = SharedPrefs.getRegistered();

//   if (token != null && token.isNotEmpty) {
//     // User is logged in
//     if (isRegistered) {
//       Get.offAll(() =>  InvestmentHomeScreen());
//     } else {
//       Get.offAll(() =>  UserBasicDetailsPage());
//     }
//   } else {
//     // No token → take to login
//     Get.to(() => LoginScreen());
//   }
// },

                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
