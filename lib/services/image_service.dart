import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final _picker = ImagePicker();

  Future<String?> pickAndSaveImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      // Just return the path of the picked file
      return pickedFile.path;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
} 