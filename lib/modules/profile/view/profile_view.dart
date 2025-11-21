import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeram_investment_app/modules/auth/login/login_screen.dart';
import 'package:shreeram_investment_app/modules/bankdetails/view/bank_details.dart';
import 'package:shreeram_investment_app/modules/home/view/home_view.dart';
import 'package:shreeram_investment_app/modules/profile/widgets/documents_page.dart';
import 'package:shreeram_investment_app/modules/profile/widgets/general_details.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = Get.put(ProfileController());

  
@override
  void initState() {
    super.initState();
    controller.fetchProfile();
  }

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
            // Profile section
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

                Obx((){
                 
                   return  Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
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
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                );
                }),

//                 Obx(() {
//   final isCompleted = controller.isKycCompleted;

//   return GestureDetector(
//     onTap: isCompleted ? null : () {
//       Get.to(() => BankDetailsPage());
//     },
//     child: Container(
//       decoration: BoxDecoration(
//         color: isCompleted ? Colors.green : Colors.red.shade400,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       child: Text(
//         isCompleted ? "KYC Completed" : "KYC Pending",
//         style: const TextStyle(color: Colors.white, fontSize: 12),
//       ),
//     ),
//   );
// }),

               
                GestureDetector(
                  onTap: (){
                    Get.to(() => BankDetailsPage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: const Text(
                      "KYC pending",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // KYC Reminder Section
            // const Text(
            //   "COMPLETE BONDS KYC",
            //   style: TextStyle(
            //     color: Colors.grey,
            //     fontSize: 13,
            //     letterSpacing: 0.5,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // GestureDetector(
            //   onTap: controller.completeKYC,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: const Color(0xFFB38200),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            //     child: Row(
            //       children: [
            //         Container(
            //           decoration: const BoxDecoration(
            //             color: Colors.amber,
            //             shape: BoxShape.circle,
            //           ),
            //           padding: const EdgeInsets.all(6),
            //           child: const Icon(Icons.access_time,
            //               color: Colors.black, size: 20),
            //         ),
            //         const SizedBox(width: 12),
            //         const Expanded(
            //           child: Text(
            //             "You left your KYC midway\nComplete KYC →",
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 14,
            //               height: 1.3,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            const SizedBox(height: 20),

            // Menu items
            _buildMenuItem(
              icon: Icons.person_outline,
              title: "General details",
              onTap: (){
                Get.to(() => GeneralDetailsPage());
              },
            ),
            _buildMenuItem(
              icon: Icons.account_balance_outlined,
              title: "Bank details",
              onTap:(){},
            ),
            _buildMenuItem(
              icon: Icons.file_download_outlined,
              title: "Reports & documents",
              onTap: (){
                Get.to(() => DocumentsPage());
              },
            ),
            // _buildMenuItem(
            //   icon: Icons.account_balance_outlined,
            //   title: "Payment methods",
            //   onTap: controller.openBankDetails,
            // ),
            
            _buildMenuItem(
              icon: Icons.logout_outlined,
              title: "Logout",
              onTap: (){
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              Get.back(); // Close popup
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              // REMOVE TOKEN
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove("token");

              // Navigate to Login Page
              Get.offAll(() => LoginScreen());
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

}
