import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/home/model/home_model.dart';


class HomeController extends GetxController {
  var bonds = <Bond>[].obs;
  var currentBanner = 0.obs;

  final bannerList = [
    {"title": "Exclusive Offers", "image": "assets/images/banner1.jpg"},
    {"title": "High Returns Bonds", "image": "assets/images/banner2.jpg"},
    {"title": "Limited Period 0.25% Extra", "image": "assets/images/banner3.jpg"},
    {"title": "Secure & Trusted Investments", "image": "assets/images/banner4.jpg"},
  ];

  @override
  void onInit() {
    super.onInit();
    loadBonds();
  }

  void loadBonds() {
    bonds.value = [
      Bond(
        name: "Navi-2 Apr'25",
        rate: 11.25,
        maturity: "3–7 months left",
        minInvestment: 10000,
        status: "99% Sold",
      ),
    ];
  }
}
