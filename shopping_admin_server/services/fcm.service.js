const admin = require('firebase-admin');

class FCMService {
  static initialized = false;

  static initialize() {
    if (this.initialized) return;

    try {
      // Initialize với service account key
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
          privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
        }),
      });
      
      this.initialized = true;
      console.log('✅ Firebase Admin SDK initialized');
    } catch (error) {
      console.error('❌ Firebase Admin initialization error:', error);
    }
  }

  static async sendToTopic(topic, notification, data = {}) {
    this.initialize();

    try {
      const message = {
        topic,
        notification,
        data: {
          ...data,
          timestamp: new Date().toISOString(),
        },
        android: {
          priority: 'high',
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
            },
          },
        },
      };

      const response = await admin.messaging().send(message);
      console.log('✅ FCM sent successfully:', response);
      return { success: true, messageId: response };
    } catch (error) {
      console.error('❌ FCM send error:', error);
      return { success: false, error: error.message };
    }
  }

  static async sendToToken(token, notification, data = {}) {
    this.initialize();

    try {
      const message = {
        token,
        notification,
        data: {
          ...data,
          timestamp: new Date().toISOString(),
        },
        android: {
          priority: 'high',
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
            },
          },
        },
      };

      const response = await admin.messaging().send(message);
      console.log('✅ FCM sent to token:', response);
      return { success: true, messageId: response };
    } catch (error) {
      console.error('❌ FCM send to token error:', error);
      return { success: false, error: error.message };
    }
  }

  static async sendProductNotification(action, product) {
    const notifications = {
      created: {
        title: '🎉 Sản phẩm mới!',
        body: `Đã thêm "${product.name}" vào cửa hàng`,
      },
      updated: {
        title: '✏️ Cập nhật sản phẩm',
        body: `Đã cập nhật thông tin "${product.name}"`,
      },
      deleted: {
        title: '🗑️ Xóa sản phẩm',
        body: `Đã xóa "${product.name}" khỏi cửa hàng`,
      },
    };

    const notification = notifications[action];
    if (!notification) return;

    return await this.sendToTopic('product_updates', notification, {
      action,
      productId: product._id?.toString(),
      productName: product.name,
    });
  }

  static async sendOrderNotification(order) {
    return await this.sendToTopic(
      'new_orders',
      {
        title: '📦 Đơn hàng mới!',
        body: `Đơn hàng #${order._id} - ${order.customerName}`,
      },
      {
        orderId: order._id?.toString(),
        customerName: order.customerName,
        total: order.total?.toString(),
      }
    );
  }

  static async sendAdminNotification(title, body, data = {}) {
    return await this.sendToTopic(
      'admin_notifications',
      { title, body },
      data
    );
  }
}

module.exports = FCMService;
