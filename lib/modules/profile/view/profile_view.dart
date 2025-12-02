import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeram_investment_app/main.dart';
import 'package:shreeram_investment_app/modules/auth/bank_info/bank_info.dart';
import 'package:shreeram_investment_app/modules/auth/login/login_screen.dart';
import 'package:shreeram_investment_app/modules/bankdetails/view/bank_details.dart';
import 'package:shreeram_investment_app/modules/home/view/home_view.dart';
import 'package:shreeram_investment_app/modules/profile/widgets/documents_page.dart';
import 'package:shreeram_investment_app/modules/profile/widgets/general_details.dart';
import 'package:shreeram_investment_app/modules/refer/view/refer_page.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  final ProfileController controller = Get.put(ProfileController());

  bool isKycCompleted = false;

  @override
  void initState() {
    super.initState();
    controller.fetchProfile();
    _loadKycStatus(); // 🔹 Load saved KYC status
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the current route shows up again
    _loadKycStatus(); // Reload KYC status when coming back to this page
  }

Future<void> _loadKycStatus() async {
  String? status = await SharedPrefs.getBankVerifyStatusAsync();

  setState(() {
    isKycCompleted = (status?.toLowerCase() == "verified");
  });
}



  /// 🔹 Call this when user finishes KYC steps
  // Future<void> markKycCompleted() async {
  //   await SharedPrefs.setKycStatus("Verified");

  //   setState(() {
  //     isKycCompleted = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAll(() => InvestmentHomeScreen()),
        ),
        title: const Text(
          "Profile Details",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "AC",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Obx(() {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.user.value?.name ?? "Account Holder",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Account Details",
                          style:
                              TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }),

                // 🔥 KYC STATUS BOX (Dynamic like website)
                GestureDetector(
                  onTap: isKycCompleted
                      ? null
                      : () {
                          Get.to(() => BankDetailsPage());
                        },
                  child: Container(
  decoration: BoxDecoration(
    color: isKycCompleted ? Colors.green : Colors.red.shade400,
    borderRadius: BorderRadius.circular(6),
  ),
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  child: Text(
    isKycCompleted ? "KYC Completed" : "KYC Pending",
    style: TextStyle(color: Colors.white, fontSize: 12),
  ),
),

                ),
              ],
            ),

            const SizedBox(height: 20),

            // Menu Items
            _buildMenuItem(
              icon: Icons.person_outline,
              title: "General details",
              onTap: () {
                Get.to(() => GeneralDetailsPage());
              },
            ),
            // _buildMenuItem(
            //   icon: Icons.account_balance_outlined,
            //   title: "Bank details",
            //   onTap: () {
            //     Get.to(() => BankInfoPage());
            //   },
            // ),
            _buildMenuItem(
              icon: Icons.file_download_outlined,
              title: "Reports & documents",
              onTap: () {
                Get.to(() => DocumentsPage());
              },
            ),
            _buildMenuItem(
              icon: Icons.card_giftcard,
              title: "Refer & Earn",
              onTap: () {
                Get.to(() => ReferEarnScreen());
              },
            ),
            _buildMenuItem(
              icon: Icons.logout_outlined,
              title: "Logout",
              onTap: () {
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey.shade300),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        Divider(color: Colors.grey.shade800, thickness: 0.2),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.remove("token");
                await prefs.remove("bankVerifyStatus");

                Get.offAll(() => LoginScreen());
              },
              child:
                  const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
