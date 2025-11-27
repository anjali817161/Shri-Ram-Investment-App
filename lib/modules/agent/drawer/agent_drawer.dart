import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeram_investment_app/modules/agent/agent_login/view/agent_login.dart';
import 'package:shreeram_investment_app/modules/agent/profile/view/agent_profile.dart';

class AgentDrawer extends StatelessWidget {
  const AgentDrawer({super.key});

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        content: const Text("Are you sure you want to logout?", style: TextStyle(color: Colors.black54)),
        actions: [
          TextButton(
            child: const Text("No", style: TextStyle(color: Colors.black87)),
            onPressed: () => Navigator.pop(context), // close popup
          ),
          TextButton(
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("token"); // 🔥 Clear token

              Get.offAll(() => AgentLoginView()); // 🔥 Redirect to login page
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF252525),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 10),
                Text("Agent Profile",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),

          // PROFILE
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white70),
            title: const Text("Profile", style: TextStyle(color: Colors.white)),
            onTap: () {
              Get.to(() => AgentProfileView());
            },
          ),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Logout",
                style: TextStyle(color: Colors.redAccent)),
            onTap: () => showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}
