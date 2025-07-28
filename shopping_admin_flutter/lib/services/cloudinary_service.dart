import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../constants.dart';

class CloudinaryService {
  static final ImagePicker _picker = ImagePicker();

  /// Upload ảnh lên Cloudinary qua server API
  static Future<String?> uploadImage({
    required String folder, // VD: 'products', 'users'
    File? file,
    Uint8List? bytes, 
    XFile? xFile,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/v1/upload/image');
      
      var request = http.MultipartRequest('POST', uri);
      
      request.fields['folder'] = folder;
      
      http.MultipartFile multipartFile;
      
      if (file != null) {
        multipartFile = await http.MultipartFile.fromPath(
          'image', 
          file.path,
          contentType: MediaType('image', 'jpeg'), 
        );
        request.files.add(multipartFile);
      } else if (xFile != null) {
        if (xFile.path.isNotEmpty) {
          String contentType = 'image/jpeg'; // Default
          if (xFile.name.toLowerCase().endsWith('.png')) {
            contentType = 'image/png';
          } else if (xFile.name.toLowerCase().endsWith('.gif')) {
            contentType = 'image/gif';
          } else if (xFile.name.toLowerCase().endsWith('.webp')) {
            contentType = 'image/webp';
          }
          
          multipartFile = await http.MultipartFile.fromPath(
            'image',
            xFile.path,
            contentType: MediaType.parse(contentType),
          );
          request.files.add(multipartFile);
        } else {
          final bytes = await xFile.readAsBytes();
          String contentType = 'image/jpeg'; // Default
          if (xFile.name.toLowerCase().endsWith('.png')) {
            contentType = 'image/png';
          } else if (xFile.name.toLowerCase().endsWith('.gif')) {
            contentType = 'image/gif';
          } else if (xFile.name.toLowerCase().endsWith('.webp')) {
            contentType = 'image/webp';
          }
          
          multipartFile = http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: xFile.name,
            contentType: MediaType.parse(contentType),
          );
          request.files.add(multipartFile);
        }
      } else if (bytes != null) {
        multipartFile = http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      } else {
        throw Exception('Cần có file, bytes hoặc xFile để upload');
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseBody);
        
        if (data['success'] == true) {
          final String imageUrl = data['data']['url'];
          print('Upload qua server thành công: $imageUrl');
          return imageUrl;
        } else {
          throw Exception(data['message'] ?? 'Lỗi không xác định');
        }
      } else {
        print('Lỗi upload qua server: ${response.statusCode} - $responseBody');
        final Map<String, dynamic> errorData = json.decode(responseBody);
        throw Exception(errorData['message'] ?? 'Lỗi server');
      }
    } catch (e) {
      print('Lỗi upload ảnh qua server: $e');
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

  static Future<String?> uploadProductImage(XFile imageFile) async {
    try {
      return await uploadImage(
        folder: 'products',
        xFile: imageFile,
      );
    } catch (e) {
      print('Lỗi upload ảnh sản phẩm: $e');
      throw Exception('Lỗi upload ảnh sản phẩm: $e');
    }
  }

  static Future<bool> deleteImage(String imageUrl) async {
    try {
      final publicId = getPublicIdFromUrl(imageUrl);
      if (publicId == null) {
        print('Không thể lấy public_id từ URL: $imageUrl');
        return false;
      }

      final uri = Uri.parse('$baseUrl/v1/upload/image/$publicId');
      
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('Xóa ảnh qua server thành công');
          return true;
        }
      }
      
      print('Lỗi xóa ảnh qua server: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Lỗi xóa ảnh: $e');
      return false;
    }
  }

  /// Lấy public_id từ Cloudinary URL
  static String? getPublicIdFromUrl(String imageUrl) {
    try {
      // URL format: https://res.cloudinary.com/cloud_name/image/upload/v1234567890/folder/filename.jpg
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      
      final uploadIndex = pathSegments.indexOf('upload');
      if (uploadIndex == -1 || uploadIndex + 2 >= pathSegments.length) {
        return null;
      }
      
      final publicIdWithExtension = pathSegments.sublist(uploadIndex + 2).join('/');
      final publicId = publicIdWithExtension.split('.').first;
      
      return publicId;
    } catch (e) {
      print('Lỗi parse public_id: $e');
      return null;
    }
  }
}
