import 'dart:io';
import 'dart:ui' as BorderType;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shreeram_investment_app/modules/kyc/widgest/dasshed_border.dart';
import 'package:shreeram_investment_app/modules/nominee/view/add_nominee.dart';
import 'package:shreeram_investment_app/modules/profile/controller/profile_controller.dart';
import '../controller/kyc_controller.dart';

class KycUploadScreen extends StatelessWidget {
  final KycController controller = Get.put(KycController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "KYC Document Upload",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Please upload clear images or PDFs of your Aadhaar and PAN cards.",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 25),

            _buildUploadBox(
              title: "Aadhaar Card - Front",
              file: controller.adharFront,
              onTap: () => controller.pickAnyFile(controller.adharFront),
            ),
            const SizedBox(height: 20),

            _buildUploadBox(
              title: "Aadhaar Card - Back",
              file: controller.adharBack,
              onTap: () => controller.pickAnyFile(controller.adharBack),
            ),
            const SizedBox(height: 20),

            _buildUploadBox(
              title: "PAN Card",
              file: controller.panCard,
              onTap: () => controller.pickAnyFile(controller.panCard),
            ),

            const SizedBox(height: 40),

            // ---------------- SUBMIT BUTTON ----------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final user = profileController.user.value;
  controller.submitKyc( user?.id ?? "");
                },


                child: const Text(
                  "Submit Documents",
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🔹 Upload box builder
  
Widget _buildUploadBox({
  required String title,
  required Rx<File?> file,
  required VoidCallback onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: onTap,
        child: Obx(() {
          return DashedBorder(
            color: Colors.white38,
            strokeWidth: 1.2,
            dashArray: const [8, 6],
            radius: const Radius.circular(12),
            padding: const EdgeInsets.all(0),
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(12),
              ),
              child: file.value == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.upload_file, size: 40, color: Colors.white38),
                        SizedBox(height: 8),
                        Text(
                          "Upload Document",
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Tap to choose image or PDF",
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: file.value!.path.toLowerCase().endsWith('.pdf')
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.picture_as_pdf, color: Colors.white70, size: 48),
                                  const SizedBox(height: 8),
                                  Text(
                                    file.value!.path.split('/').last,
                                    style: const TextStyle(color: Colors.white70),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : Image.file(
                              file.value!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
            ),
          );
        }),
      ),
    ],
  );
}
}
