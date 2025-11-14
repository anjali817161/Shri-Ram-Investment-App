import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/bankdetails/view/image_preview.dart';

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
      Get.to(() => ImagePreviewPage(imagePath: image.path));
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

  @override
  Widget build(BuildContext context) {
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
