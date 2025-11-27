import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/navbar/navbar_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavBarController navController = Get.put(NavBarController());

    return Obx(() => BottomNavigationBar(
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      currentIndex: navController.currentIndex.value,
      onTap: navController.changeTab,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'FDs'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet), label: 'Portfolio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard), label: 'KYC'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
      ],
    ));
  }
}
