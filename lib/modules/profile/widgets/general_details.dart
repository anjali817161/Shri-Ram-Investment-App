import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/profile/controller/profile_controller.dart';

class GeneralDetailsPage extends StatefulWidget {

  GeneralDetailsPage({super.key});

  @override
  State<GeneralDetailsPage> createState() => _GeneralDetailsPageState();
}

class _GeneralDetailsPageState extends State<GeneralDetailsPage> {
  final ProfileController controller = Get.find<ProfileController>();

  final TextEditingController nameCtrl = TextEditingController();

  final TextEditingController emailCtrl = TextEditingController();

  final TextEditingController phoneCtrl = TextEditingController();



  
    @override
    void initState() {
      super.initState();
      controller.fetchProfile();

       ever(controller.user, (userData) {
      if (userData != null) {
        nameCtrl.text = userData.name ?? "";
        emailCtrl.text = userData.email ?? "";
        phoneCtrl.text = userData.phone ?? "";
      }
    });
    }
    
   

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("General Details"),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

           
              buildField(
                
                label: "Name",
                controller: nameCtrl,
                isEditing: controller.isEditingName.value,
                onEdit: controller.editName,
                onSave: () => controller.updateSingleField("name", nameCtrl.text),
              ),

              const SizedBox(height: 16),
              
          

              buildField(
                label: "Email",
                controller: emailCtrl,
                isEditing: controller.isEditingEmail.value,
                onEdit: controller.editEmail,
                onSave: () => controller.updateSingleField("email", emailCtrl.text),
              ),

              const SizedBox(height: 16),
              
     

              buildField(
                label: "Phone",
                controller: phoneCtrl,
                isEditing: controller.isEditingPhone.value,
                onEdit: controller.editPhone,
                onSave: () => controller.updateSingleField("phone", phoneCtrl.text),
              ),
            ],
          ),
        );
      }),
    );
  }

Widget buildField({
  required String label,
  required TextEditingController controller,
  required bool isEditing,
  required VoidCallback onEdit,
  required VoidCallback onSave,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
    decoration: BoxDecoration(
      color: Colors.grey.shade900,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 6),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text OR Editable Field
            Expanded(
              child: isEditing
                  ? TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    )
                  : Text(
                      controller.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),

            const SizedBox(width: 8),

            // Button (Edit / Save)
            isEditing
                ? InkWell(
                    onTap: onSave,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: onEdit,
                  ),
          ],
        ),
      ],
    ),
  );
}

}
