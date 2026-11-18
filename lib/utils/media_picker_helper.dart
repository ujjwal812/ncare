import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaPickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from Camera or Gallery with permission requests & fallback dialogs
  static Future<File?> pickImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    try {
      bool hasPermission = await _requestPermission(context, source);
      if (!hasPermission) return null;

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        if (context.mounted) {
          _showSnackBar(
            context,
            source == ImageSource.camera
                ? 'Camera photo captured successfully!'
                : 'Photo selected from gallery!',
            isSuccess: true,
          );
        }
        return file;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (context.mounted) {
        _showSnackBar(
          context,
          'Unable to open ${source == ImageSource.camera ? "camera" : "gallery"}. Please try again.',
          isSuccess: false,
        );
      }
    }
    return null;
  }

  static Future<bool> _requestPermission(
    BuildContext context,
    ImageSource source,
  ) async {
    if (source == ImageSource.camera) {
      var status = await Permission.camera.status;
      if (status.isGranted) return true;

      status = await Permission.camera.request();
      if (status.isGranted) return true;

      if (context.mounted) {
        _showPermissionSettingsDialog(
          context,
          title: 'Camera Permission Required',
          message:
              'Camera access is required to capture photos/prescriptions. Please allow camera permission in app settings.',
        );
      }
      return false;
    } else {
      // Gallery / Photos selection
      if (Platform.isAndroid) {
        // Android 13+ (API 33+) uses system photo picker, no explicit storage permission needed for ImagePicker
        var photosStatus = await Permission.photos.status;
        var storageStatus = await Permission.storage.status;

        if (photosStatus.isGranted || photosStatus.isLimited || storageStatus.isGranted) {
          return true;
        }

        // Request permission if not already granted
        var reqPhotos = await Permission.photos.request();
        if (reqPhotos.isGranted || reqPhotos.isLimited) return true;

        var reqStorage = await Permission.storage.request();
        if (reqStorage.isGranted) return true;

        if ((reqPhotos.isPermanentlyDenied || reqStorage.isPermanentlyDenied) && context.mounted) {
          _showPermissionSettingsDialog(
            context,
            title: 'Gallery Permission Required',
            message:
                'Gallery access is required to choose photos. Please allow storage/photos permission in app settings.',
          );
          return false;
        }
      }
    }
    return true;
  }

  static void _showPermissionSettingsDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.security, color: Color(0xFF3880C9)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3880C9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Open Settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    bool isSuccess = true,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_outline : Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? const Color(0xFF3880C9) : Colors.redAccent,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
