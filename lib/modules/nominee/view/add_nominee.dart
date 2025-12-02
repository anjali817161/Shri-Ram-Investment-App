import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/nominee/controller/nominee_controller.dart';
import 'package:shreeram_investment_app/modules/profile/view/profile_view.dart';

class AddNomineeScreen extends StatefulWidget {
  const AddNomineeScreen({super.key});

  @override
  State<AddNomineeScreen> createState() => _AddNomineeScreenState();
}

class _AddNomineeScreenState extends State<AddNomineeScreen> {
  final NomineeController controller = Get.put(NomineeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Add Nominee", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // ⬅️ BACK NAVIGATION
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Title
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.group, color: Colors.white70, size: 42),
                    SizedBox(height: 10),

                    Text(
                      "Protect your investments by adding a nominee to your account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              _buildTextField("Nominee's Name", controller.nomineeNameCtrl),

              const SizedBox(height: 16),

              _buildDropdown(
                title: "Relation",
                value: controller.selectedRelation,
                items: ["Father", "Mother", "Spouse", "Son", "Daughter"],
                onChanged: (val) => setState(() => controller.selectedRelation = val),
              ),

              const SizedBox(height: 22),

              const Text("Date of Birth", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(child: _buildTextField("DD", controller.dobDDCtrl)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField("MM", controller.dobMMCtrl)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField("YYYY", controller.dobYYCtrl)),
                ],
              ),

              const SizedBox(height: 20),

              const Text("Nominee Proof", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      title: "Aadhaar",
                      value: controller.selectedProof,
                      items: ["Aadhaar", "Aadhaar card", "PAN", "VoterID", "Passport", "Other"],
                      onChanged: (val) => setState(() => controller.selectedProof = val),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField(
                    controller.selectedProof == "Aadhaar" ? "Full Aadhaar Number" : "Last 4 digits",
                    controller.lastDigitsCtrl
                  )),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: controller.sameAddress,
                    onChanged: (val) => setState(() => controller.sameAddress = val!),
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                  ),
                  const Expanded(
                    child: Text(
                      "Nominee address is same as my permanent address",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: _buildWhiteButton("Back", onTap: () {
                      Navigator.pop(context); // BACK
                    }),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: _buildYellowButton("Skip", onTap: () {
                      controller.goToNextScreen(); // SKIP NEXT
                    }),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: _buildBlackButton("Complete", onTap: () async {
                      await controller.submitNominee();
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ METHODS ---------------------

  // --------------- Widgets ---------------------

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String title,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: const Color(0xFF2A2A2A),
          value: value,
          hint: Text(title, style: const TextStyle(color: Colors.white38)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          style: const TextStyle(color: Colors.white),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildWhiteButton(String title, {required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white24,
        ),
        child: Center(
          child: Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildYellowButton(String title, {required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.yellow),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.yellow, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildBlackButton(String title, {required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
