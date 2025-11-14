import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shreeram_investment_app/modules/navbar/bottom_navbar.dart';
import '../controller/home_controller.dart';

class InvestmentHomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  final List<Map<String, dynamic>> popularList = [
    {
      "rank": 1,
      "name": "Punjab National Bank",
      "image": "assets/images/pnb_logo.png",
      "rate": "6.6%",
      "oldRate": "11.25%",
      "duration": "12 months",
      "color": Colors.amber
    },
    {
      "rank": 2,
      "name": "Indian Post Payment Bank",
      "image": "assets/images/post_logo.png",
      "rate": "6.9%",
      "oldRate": "11%",
      "duration": "12 months",
      "color": const Color.fromARGB(255, 147, 190, 211)
    },
    {
      "rank": 3,
      "name": "Shri Ram Investment",
      "image": "assets/images/shri_icon.png",
      "rate": "10.9%",
      "oldRate": "10.5%",
      "duration": "24 months",
      "color": const Color.fromARGB(255, 198, 143, 123)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Top logo and name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/shri_icon.png', height: 45),
                     SizedBox(width: 128,),
                      const Text(
                        "Shree Ram Investment",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Image + Text Slider
              Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: controller.bannerList.length,
                    itemBuilder: (context, index, realIdx) {
                      final banner = controller.bannerList[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(banner["image"]!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              banner["title"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 160,
                      viewportFraction: 0.9,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, _) =>
                          controller.currentBanner.value = index,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.bannerList.length,
                      (index) => Obx(() => Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: controller.currentBanner.value == index
                                ? 16
                                : 6,
                            decoration: BoxDecoration(
                              color:
                                  controller.currentBanner.value == index
                                      ? Colors.white
                                      : Colors.white38,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Offer Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2B0E3E), Color(0xFF1A0723)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Exclusive",
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(height: 4),
                    Text("Additional 0.25%",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("on all bonds (via 0 brokerage)",
                        style: TextStyle(color: Colors.white54, fontSize: 14)),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("ENDS IN 7 DAYS",
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Bond Card
              Obx(() {
                final bond = controller.bonds.first;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber[800],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            bond.status,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("${bond.rate.toStringAsFixed(2)}%",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold)),
                      const Text("YTM upto",
                          style: TextStyle(color: Colors.white54, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text("Maturity: ${bond.maturity}",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(bond.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text("₹${bond.minInvestment.toStringAsFixed(0)} min. investment",
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 30),

              // 🔹 Categories
              const Text("SELECT A CATEGORY",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildCategory(Icons.flash_on, "Short tenure"),
                    _buildCategory(Icons.star_rate, "High rated"),
                    _buildCategory(Icons.trending_up, "High returns"),
                    _buildCategory(Icons.currency_rupee, "Invest with ₹1k"),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // 🔹 Popular on Wint Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Popular on Shri Ram",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  // Text("View More",
                  //     style: TextStyle(
                  //         color: Colors.greenAccent,
                  //         fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 12),

              Column(
                children: List.generate(popularList.length, (index) {
                  final item = popularList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: item["color"].withOpacity(0.4), width: 1.2),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: item["color"],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  bottomRight: Radius.circular(14)),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Text(
                              "${item["rank"]}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 35, 16, 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                   Image.asset(item["image"], height: 35),
                     SizedBox(width: 12,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item["name"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 6),
                                      Text("Tenure:" + item["duration"],
                                          style: const TextStyle(
                                              color: Colors.white54, fontSize: 13)),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("YTM upto",
                                      style: const TextStyle(
                                          color: Colors.white54, fontSize: 13)),
                                  Text(item["rate"],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    item["oldRate"],
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.amberAccent, size: 26),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
