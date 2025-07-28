import '../services/fcm_service.dart';
import '../models/product_model.dart';

class NotificationHelper {
  
  /// Gửi thông báo khi tạo sản phẩm mới
  static Future<void> sendProductCreatedNotification(Product product) async {
    await FCMService.sendNotificationToTopic(
      topic: 'product_updates',
      title: '🆕 Sản phẩm mới',
      body: 'Đã thêm sản phẩm: ${product.name}',
      data: {
        'type': 'product_created',
        'product_id': product.id,
        'product_name': product.name,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    print('✅ Sent product created notification: ${product.name}');
  }

  /// Gửi thông báo khi cập nhật sản phẩm
  static Future<void> sendProductUpdatedNotification(Product product) async {
    await FCMService.sendNotificationToTopic(
      topic: 'product_updates',
      title: '📝 Cập nhật sản phẩm',
      body: 'Đã cập nhật sản phẩm: ${product.name}',
      data: {
        'type': 'product_updated',
        'product_id': product.id,
        'product_name': product.name,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    print('✅ Sent product updated notification: ${product.name}');
  }

  /// Gửi thông báo khi xóa sản phẩm
  static Future<void> sendProductDeletedNotification(String productName) async {
    await FCMService.sendNotificationToTopic(
      topic: 'product_updates',
      title: '🗑️ Đã xóa sản phẩm', 
      body: 'Đã xóa sản phẩm: $productName',
      data: {
        'type': 'product_deleted',
        'product_name': productName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    print('✅ Sent product deleted notification: $productName');
  }

  /// Gửi thông báo admin tổng quát
  static Future<void> sendAdminNotification(String title, String body, {Map<String, dynamic>? data}) async {
    await FCMService.sendNotificationToTopic(
      topic: 'admin_notifications',
      title: title,
      body: body,
      data: data ?? {},
    );
    
    print('✅ Sent admin notification: $title');
  }

  /// Gửi thông báo thống kê hàng ngày
  static Future<void> sendDailyStatsNotification(int totalProducts) async {
    await FCMService.sendNotificationToTopic(
      topic: 'admin_notifications',
      title: '📊 Thống kê hôm nay',
      body: 'Hiện có $totalProducts sản phẩm trong hệ thống',
      data: {
        'type': 'daily_stats',
        'total_products': totalProducts.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    print('✅ Sent daily stats notification');
  }
}
