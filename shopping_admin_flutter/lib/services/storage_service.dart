import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final ImagePicker _picker = ImagePicker();

  /// Upload ảnh lên Firebase Storage
  /// Trả về URL của ảnh đã upload
  static Future<String?> uploadImage({
    required String folder, // VD: 'products', 'users'
    required String fileName, // VD: 'product_1.jpg'
    File? file,
    Uint8List? bytes, // Cho web
  }) async {
    try {
      // Kiểm tra Firebase Storage có được khởi tạo không
      if (_storage.bucket.isEmpty) {
        throw Exception('Firebase Storage chưa được cấu hình');
      }

      // Tạo reference đến file trên Storage
      final Reference ref = _storage.ref().child('$folder/$fileName');
      
      UploadTask uploadTask;
      
      if (file != null) {
        // Upload từ File (mobile)
        uploadTask = ref.putFile(file);
      } else if (bytes != null) {
        // Upload từ bytes (web)
        uploadTask = ref.putData(bytes);
      } else {
        throw Exception('Cần có file hoặc bytes để upload');
      }

      // Đợi upload hoàn thành
      final TaskSnapshot snapshot = await uploadTask;
      
      // Lấy URL download
      final String downloadURL = await snapshot.ref.getDownloadURL();
      
      print('Upload thành công: $downloadURL');
      return downloadURL;
    } on FirebaseException catch (e) {
      print('Firebase Storage Error: ${e.code} - ${e.message}');
      if (e.code == 'storage/unauthorized') {
        throw Exception('Không có quyền truy cập Firebase Storage. Vui lòng kiểm tra rules.');
      } else if (e.code == 'storage/quota-exceeded') {
        throw Exception('Hết dung lượng Firebase Storage.');
      } else if (e.code == 'storage/bucket-not-found') {
        throw Exception('Không tìm thấy Firebase Storage bucket.');
      } else {
        throw Exception('Lỗi Firebase Storage: ${e.message}');
      }
    } catch (e) {
      print('Lỗi upload ảnh: $e');
      throw Exception('Lỗi upload ảnh: $e');
    }
  }

  /// Chọn ảnh từ gallery
  static Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      print('Lỗi chọn ảnh: $e');
      return null;
    }
  }

  /// Chọn ảnh từ camera
  static Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      print('Lỗi chụp ảnh: $e');
      return null;
    }
  }

  /// Xóa ảnh từ Firebase Storage
  static Future<bool> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      print('Xóa ảnh thành công');
      return true;
    } catch (e) {
      print('Lỗi xóa ảnh: $e');
      return false;
    }
  }

  /// Upload ảnh sản phẩm với tên file tự động
  static Future<String?> uploadProductImage(XFile imageFile) async {
    try {
      final String fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      if (imageFile.path.isNotEmpty) {
        // Mobile - có path
        final File file = File(imageFile.path);
        return await uploadImage(
          folder: 'products',
          fileName: fileName,
          file: file,
        );
      } else {
        // Web - không có path, dùng bytes
        final Uint8List bytes = await imageFile.readAsBytes();
        return await uploadImage(
          folder: 'products',
          fileName: fileName,
          bytes: bytes,
        );
      }
    } catch (e) {
      print('Lỗi upload ảnh sản phẩm: $e');
      return null;
    }
  }

  /// Show dialog chọn source (Gallery hoặc Camera)
  static Future<XFile?> showImageSourceDialog() async {
    // Này sẽ được implement trong UI
    // Trả về null để báo user cancel
    return null;
  }
}
