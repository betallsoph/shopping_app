#!/bin/bash

echo "🔥 Firebase Setup Script cho Shopping Admin Flutter"
echo "=================================================="

echo ""
echo "📋 Bước 1: Tạo Firebase Project"
echo "1. Đi tới https://console.firebase.google.com/"
echo "2. Nhấp 'Create a project'"
echo "3. Đặt tên: 'shopping-admin-flutter'"
echo "4. Disable Google Analytics (không bắt buộc)"
echo "5. Nhấp 'Create project'"
echo ""
echo "📋 Bước 2: Enable Google Authentication"
echo "1. Vào 'Authentication' > 'Get started'"
echo "2. Chọn 'Sign-in method'"
echo "3. Enable 'Google'"
echo "4. Chọn support email và Save"
echo ""

read -p "✅ Đã hoàn thành 2 bước trên? (y/n): " ready

if [ "$ready" != "y" ]; then
    echo "❌ Vui lòng hoàn thành setup trên Firebase Console trước khi tiếp tục"
    exit 1
fi

echo ""
echo "🚀 Bước 3: Login Firebase CLI"
firebase login

echo ""
echo "⚙️  Bước 4: Configure FlutterFire"
flutterfire configure

echo ""
echo "🔧 Bước 5: Uncomment Firebase code"
echo "Đang cập nhật main.dart..."

# Uncomment Firebase code in main.dart
sed -i '' 's|// import '\''package:firebase_core/firebase_core.dart'\'';|import '\''package:firebase_core/firebase_core.dart'\'';|g' lib/main.dart
sed -i '' 's|// import '\''firebase_options.dart'\'';|import '\''firebase_options.dart'\'';|g' lib/main.dart
sed -i '' 's|  // TODO: Uncomment after running '\''flutterfire configure'\''||g' lib/main.dart
sed -i '' 's|  // await Firebase.initializeApp(|  await Firebase.initializeApp(|g' lib/main.dart
sed -i '' 's|  //   options: DefaultFirebaseOptions.currentPlatform,|    options: DefaultFirebaseOptions.currentPlatform,|g' lib/main.dart
sed -i '' 's|  // );|  );|g' lib/main.dart

echo "✅ Đã cập nhật main.dart"

echo ""
echo "🎉 Setup hoàn thành!"
echo "Bây giờ bạn có thể chạy:"
echo "  flutter run"
echo ""
echo "📱 Để test Google Sign-In:"
echo "  - Trên Android: cần device thật hoặc emulator có Google Play"
echo "  - Trên iOS: cần thêm URL scheme vào Info.plist"
echo "  - Trên Web: cần config authorized domains"
