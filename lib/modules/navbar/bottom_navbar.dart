import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/bankdetails/view/bank_details.dart';
import 'package:shreeram_investment_app/modules/kyc/view/kyc_upload.dart';
import 'package:shreeram_investment_app/modules/more/view/more_view.dart';
import 'package:shreeram_investment_app/modules/portfolio/view/portfolio_view.dart';
import 'package:shreeram_investment_app/modules/profile/view/profile_view.dart';
import 'package:shreeram_investment_app/modules/refer/view/refer_page.dart';
import '../home/view/home_view.dart' as home_view;

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offAll(() => home_view.InvestmentHomeScreen());
            break;
          case 1:
            // navigate to PortfolioView()
            Get.off(() => PortfolioView());
            break;
          case 2:
            // navigate to ReferAndEarnView()
            Get.off(() => BankDetailsPage());

            break;
          case 3:
            // navigate to MoreView()
                Get.off(() => ProfilePage());

            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'FDs'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet), label: 'Portfolio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard), label: 'KYC'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
      ],
    );
  }
}
