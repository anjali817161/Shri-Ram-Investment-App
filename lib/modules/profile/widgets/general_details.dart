import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/profile/controller/profile_controller.dart';

class GeneralDetailsPage extends StatefulWidget {
  const GeneralDetailsPage({super.key});

  @override
  State<GeneralDetailsPage> createState() => _GeneralDetailsPageState();
}

class _GeneralDetailsPageState extends State<GeneralDetailsPage> {
  late ProfileController controller;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProfileController>();
    _nameController = TextEditingController(text: controller.name.value);
    _phoneController = TextEditingController(text: controller.phone.value);
    _emailController = TextEditingController(text: controller.email.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    controller.name.value = _nameController.text;
    controller.phone.value = _phoneController.text;
    controller.email.value = _emailController.text;
    controller.saveAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E), // deep dark theme
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0E0E0E),
        title: const Text(
          "General Details",
          style: TextStyle(color: Colors.white),
        ),
        actions: const [],
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Obx(() => _buildDetailCard(
                  title: "Name",
                  controller: _nameController,
                  isEditing: controller.isEditingName.value,
                  onEdit: controller.onEditName,
                )),
            const SizedBox(height: 16),
            Obx(() => _buildDetailCard(
                  title: "Phone Number",
                  controller: _phoneController,
                  isEditing: controller.isEditingPhone.value,
                  onEdit: controller.onEditPhone,
                )),
            const SizedBox(height: 16),
            Obx(() => _buildDetailCard(
                  title: "Email Address",
                  controller: _emailController,
                  isEditing: controller.isEditingEmail.value,
                  onEdit: controller.onEditEmail,
                )),
            const SizedBox(height: 20),
            Obx(() => controller.isAnyEditing
                ? ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.black)),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  /// -------------------- DETAIL CARD --------------------
  Widget _buildDetailCard({
    required String title,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                isEditing
                    ? TextField(
                        controller: controller,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      )
                    : Text(
                        controller.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ],
            ),
          ),

          // EDIT ICON
          GestureDetector(
            onTap: onEdit,
            child: const Icon(
              Icons.edit_outlined,
              color: Colors.white38,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
