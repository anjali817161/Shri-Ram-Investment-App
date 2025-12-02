import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/auth/login/controller/login_controller.dart';
import 'package:shreeram_investment_app/modules/onboarding/view/onboarding_view.dart';
import 'package:shreeram_investment_app/modules/theme/app_theme.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  Get.put(LoginController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shri Ram Investment',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const OnboardingView(),
      navigatorObservers: [routeObserver],
    );
  }
}
