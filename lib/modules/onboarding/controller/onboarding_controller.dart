import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/onboarding/model/onboarding_model.dart';

class OnboardingController extends GetxController {
  var pageIndex = 0.obs;

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      image: 'assets/images/money1.png',
      title: 'Your money. Always within reach.',
      subtitle: 'Sell anytime. We’ll find buyers for you.',
    ),
    OnboardingModel(
      image: 'assets/images/money2.png',
      title: 'Invest Smartly with Confidence',
      subtitle: 'Track your investments in real time.',
    ),
    OnboardingModel(
      image: 'assets/images/money3.png',
      title: 'Secure. Trusted. Simple.',
      subtitle: 'Your investments are safe and transparent.',
    ),
  ];
}
