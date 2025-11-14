import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/more/view/more_view.dart';
import 'package:shreeram_investment_app/modules/profile/view/profile_view.dart';

class AddNomineeScreen extends StatefulWidget {
  const AddNomineeScreen({super.key});

  @override
  State<AddNomineeScreen> createState() => _AddNomineeScreenState();
}

class _AddNomineeScreenState extends State<AddNomineeScreen> {
  String? selectedRelation;
  String? selectedProof = "Aadhaar";
  bool sameAddress = false;

  // Text controllers to save data
  final nomineeNameCtrl = TextEditingController();
  final dobDDCtrl = TextEditingController();
  final dobMMCtrl = TextEditingController();
  final dobYYCtrl = TextEditingController();
  final lastDigitsCtrl = TextEditingController();

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

              _buildTextField("Nominee's Name", nomineeNameCtrl),

              const SizedBox(height: 16),

              _buildDropdown(
                title: "Relation",
                value: selectedRelation,
                items: ["Father", "Mother", "Spouse", "Son", "Daughter"],
                onChanged: (val) => setState(() => selectedRelation = val),
              ),

              const SizedBox(height: 22),

              const Text("Date of Birth", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(child: _buildTextField("DD", dobDDCtrl)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField("MM", dobMMCtrl)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField("YYYY", dobYYCtrl)),
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
                      value: selectedProof,
                      items: ["Aadhaar", "PAN", "Passport", "Voter ID"],
                      onChanged: (val) => setState(() => selectedProof = val),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField("Last 4 digits", lastDigitsCtrl)),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: sameAddress,
                    onChanged: (val) => setState(() => sameAddress = val!),
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
                      _goToNextScreen(); // SKIP NEXT
                    }),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: _buildBlackButton("Continue", onTap: () {
                      _saveNomineeDetails(); // SAVE + NEXT
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

  void _saveNomineeDetails() {
    if (nomineeNameCtrl.text.isEmpty ||
        selectedRelation == null ||
        dobDDCtrl.text.isEmpty ||
        dobMMCtrl.text.isEmpty ||
        dobYYCtrl.text.isEmpty ||
        lastDigitsCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // Store data (you can send it to API)
    print("Nominee Saved:");
    print("Name: ${nomineeNameCtrl.text}");
    print("Relation: $selectedRelation");
    print("DOB: ${dobDDCtrl.text}-${dobMMCtrl.text}-${dobYYCtrl.text}");
    print("Proof: $selectedProof");
    print("Last Digits: ${lastDigitsCtrl.text}");
    print("Same Address: $sameAddress");

    _goToNextScreen();
  }

  void _goToNextScreen() {
    // Replace with your next screen navigation
    Get.to(() => ProfilePage()); 
  }

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
