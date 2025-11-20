import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreeram_investment_app/modules/bankdetails/view/image_preview.dart';
import 'package:shreeram_investment_app/modules/kyc/view/kyc_upload.dart';

class CameraCapturePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraCapturePage({super.key, required this.cameras});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int selectedCameraIndex = 0;
  bool _showPreview = false;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera(selectedCameraIndex);
  }

  void _initializeCamera(int index) {
    _controller = CameraController(widget.cameras[index], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      setState(() {
        _showPreview = true;
        _imagePath = image.path;
      });
      // Dispose controller to stop camera and fix loop
      _controller.dispose();
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  void _flipCamera() {
    if (widget.cameras.length > 1) {
      selectedCameraIndex = (selectedCameraIndex + 1) % widget.cameras.length;
      _initializeCamera(selectedCameraIndex);
    } else {
      Get.snackbar('Flip Camera', 'Only one camera available');
    }
  }

  Future<void> _submitImage() async {
    if (_imagePath != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("capturedImagePath", _imagePath!);
      print("Image path saved to local storage: $_imagePath");

      // Verify by retrieving
      String? savedPath = prefs.getString("capturedImagePath");
      print("Verification - Saved image path: $savedPath");

      Get.snackbar(
        'Success',
        'Image submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );

      // TODO: Navigate to next page

      Get.to(() => KycUploadScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showPreview && _imagePath != null) {
      // Show preview
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
                "Preview your image",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Make sure your face is clearly visible.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Image preview
              Expanded(
                child: Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(File(_imagePath!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Submit",
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
    } else {
      // Show camera
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background preview (hidden by circular mask)
                    Center(
                      child: ClipOval(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CameraPreview(_controller),
                        ),
                      ),
                    ),

                    // Circular border overlay
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white70, width: 3),
                      ),
                    ),

                    // Flip Camera Button (top-right)
                    Positioned(
                      top: 30,
                      right: 20,
                      child: IconButton(
                        onPressed: _flipCamera,
                        icon: const Icon(Icons.flip_camera_android_rounded,
                            color: Colors.white, size: 30),
                      ),
                    ),

                    // Capture Button (bottom-center)
                    Positioned(
                      bottom: 40,
                      child: GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 3),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.black, size: 35),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
            },
          ),
        ),
      );
    }
  }
}
