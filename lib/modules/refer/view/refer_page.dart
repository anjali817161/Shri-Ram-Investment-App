import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shreeram_investment_app/modules/navbar/bottom_navbar.dart';

class ReferController extends GetxController {
  RxInt referAmount = 5000.obs; // ✅ STATIC amount for now

  // If you want increment animation every time user opens page:
  @override
  void onInit() {
    super.onInit();
    animateAmount();
  }

  void animateAmount() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i <= 5000; i += 20) {
      referAmount.value = i;
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }
}

class ReferEarnScreen extends StatelessWidget {
  final ReferController controller = Get.put(ReferController());

  ReferEarnScreen({super.key});

  // 🔥 UNIQUE STATIC TEXT
  final String shareMessage =
      "Hey! Earn ₹5000 instantly by investing in secure bonds with me on Shriram Investment App. "
      "Use my code 👉 SHREE123 and get reward benefits! 🚀📈";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text("Refer & Earn", style: TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- BLACK HEADER ----------------
            Container(
              width: double.infinity,
              height: 350,
              padding: const EdgeInsets.only(top: 190, left: 20, right: 20, bottom: 40),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Refer 5 friends & earn",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),

                  const SizedBox(height: 8),

                  // STATIC AMOUNT (animated)
                  Obx(() => Text(
                        "₹${controller.referAmount.value}",
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- TITLE ----------------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "3 SIMPLE STEPS",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ---------------- STEPS ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  stepItem(
                    step: "1",
                    title: "Refer a friend",
                    subtitle: "Share the invite link with your friends",
                  ),
                  stepItem(
                    step: "2",
                    title: "Your friend invests in bonds",
                    subtitle: "Earn up to 1.25% YTM on all their transactions",
                  ),
                  stepItem(
                    step: "3",
                    title: "Earn up to ₹5,000 per friend",
                    subtitle: "You can refer up to 5 friends",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- GREEN LOCK BAR ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: Colors.greenAccent,
              child: const Row(
                children: [
                  Icon(Icons.lock_open_rounded, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Invest in bonds to unlock referral rewards",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- SHARE BUTTON ----------------
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                children: [
                  // Share Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Share.share(shareMessage); // 🔥 DIRECT SHARE
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share, size: 18, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              "Share Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- STEP ITEM ----------------
  Widget stepItem({
    required String step,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grey Step Number Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              step,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 14),

          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
