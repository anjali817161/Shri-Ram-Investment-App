import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:shreeram_investment_app/modules/bankdetails/camera_capture.dart';

class CaptureImagePage extends StatelessWidget {
  const CaptureImagePage({super.key});

  Future<void> _openCamera(BuildContext context) async {
    // Request camera permission
    var status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        dynamic cameras = await availableCameras();
        if (cameras is List<CameraDescription> && cameras.isNotEmpty) {
          Get.to(() => CameraCapturePage(cameras: cameras));
        } else {
          Get.snackbar(
            'Error',
            'No cameras available on this device',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to access cameras: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Permission Denied',
        'Please allow camera permission to continue',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Exit",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Capture your image",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "To confirm your identity, we require your image.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Don’ts section
            const Text(
              "Don'ts",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _imageBox("assets/images/dont1.jpeg", false),
                _imageBox("assets/images/dont2.jpeg", false),
                _imageBox("assets/images/dont3.jpeg", false),
              ],
            ),

            const SizedBox(height: 30),

            // Do's section
            const Text(
              "Do's",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Center(child: _imageBox("assets/images/do.jpeg", true)),

            const Spacer(),

            // Capture button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _openCamera(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Capture image",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageBox(String assetPath, bool isDo) {
    return Container(
      height: 100,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(child: Image.asset(assetPath, fit: BoxFit.cover)),
          Positioned(
            top: 6,
            right: 6,
            child: Icon(
              isDo ? Icons.check_circle : Icons.cancel,
              color: isDo ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
