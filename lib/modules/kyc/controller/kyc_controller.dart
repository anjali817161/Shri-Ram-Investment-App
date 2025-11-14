import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';


class KycController extends GetxController {
  Rx<File?> adharFront = Rx<File?>(null);
  Rx<File?> adharBack = Rx<File?>(null);
  Rx<File?> panCard = Rx<File?>(null);

  final picker = ImagePicker();


Future<void> pickAnyFile(Rx<File?> target) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['png','jpg','jpeg','pdf'],
  );
  if (result != null && result.files.single.path != null) {
    target.value = File(result.files.single.path!);
  }
}

}
