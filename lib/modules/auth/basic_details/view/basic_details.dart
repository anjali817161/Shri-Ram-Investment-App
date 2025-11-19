import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:shreeram_investment_app/modules/auth/basic_details/controller/basic_details_Controller.dart';
import 'package:shreeram_investment_app/modules/auth/mpin/set_mpin_screen.dart';
import 'package:shreeram_investment_app/modules/home/view/home_view.dart';

class UserBasicDetailsPage extends StatefulWidget {
  const UserBasicDetailsPage({super.key});

  @override
  State<UserBasicDetailsPage> createState() => _UserBasicDetailsPageState();
}

class _UserBasicDetailsPageState extends State<UserBasicDetailsPage> {
  // Selected values
  String? selectedMarital;
  String? selectedOccupation;
  String? selectedIncome;
  String? selectedExperience;

  bool acceptDeclaration = false;

  final TextEditingController parentController = TextEditingController();
  final controller = Get.put(BasicDetailsController());

  // Reusable list of chips
  Widget buildOptionChip(String label, String? selectedValue, Function(String) onSelect) {
    final bool isSelected = label == selectedValue;

    return GestureDetector(
      onTap: () => setState(() => onSelect(label)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            width: 1.4,
          ),
          color: isSelected ? Colors.white12 : Colors.black45,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade300,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, List<String> options, String? selectedValue, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          children: options
              .map((item) => buildOptionChip(item, selectedValue, onSelect))
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Basic Details", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Marital Status
            buildSection(
              "Marital Status",
              ["Single", "Married", "Divorced", "Widowed"],
              selectedMarital,
              (val) => selectedMarital = val,
            ),

            // Occupation
            buildSection(
              "Occupation",
              [
                "Private Sector",
                "Government Service",
                "Business",
                "Agriculturalist",
                "Retired",
                "Student",
                "Other"
              ],
              selectedOccupation,
              (val) => selectedOccupation = val,
            ),

            // Annual Income
            buildSection(
              "Annual Income",
              [
                "Below ₹1L",
                "₹1L to ₹5L",
                "₹5L to ₹10L",
                "₹10L to ₹25L",
                "More than ₹25L"
              ],
              selectedIncome,
              (val) => selectedIncome = val,
            ),

            // Investment Experience
            buildSection(
              "Investment Experience",
              [
                "Below 1 year",
                "1-5 years",
                "5-10 years",
                "More than 10 years"
              ],
              selectedExperience,
              (val) => selectedExperience = val,
            ),

            // Parent/Guardian Name
            const Text(
              "Parent/Guardian Name",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: parentController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black45,
                hintText: "Parent/Guardian Name",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Checkbox
            Row(
              children: [
                Checkbox(
                  value: acceptDeclaration,
                  onChanged: (value) =>
                      setState(() => acceptDeclaration = value ?? false),
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                ),
                const Text(
                  "I accept all declarations",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () async {

  if (selectedMarital == null ||
      selectedOccupation == null ||
      selectedIncome == null ||
      selectedExperience == null ||
      parentController.text.isEmpty ||
      acceptDeclaration == false) {
    Get.snackbar("Error", "Please fill all fields");
    return;
  }

  bool success = await controller.submitBasicDetails(
    maritalStatus: selectedMarital!,
    occupation: selectedOccupation!,
    annualIncome: selectedIncome!,
    investmentExperience: selectedExperience!,
    parentName: parentController.text.trim(),
    declarationsAccepted: acceptDeclaration,
  );

  if (success) {
    Get.to(() => InvestmentHomeScreen());
  }
},

                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
