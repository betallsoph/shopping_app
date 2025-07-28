# Google Sign-In Setup cho Shopping Admin Flutter

## Đã hoàn thành:
✅ Thêm dependencies: firebase_core, firebase_auth, google_sign_in
✅ Cấu hình Firebase trong main.dart
✅ Tạo AuthService để xử lý authentication
✅ Cập nhật AuthState để tích hợp với Firebase
✅ Cải thiện UI cho trang login
✅ Cập nhật dashboard layout để hiển thị thông tin user

## Cần làm tiếp:

### 1. Cấu hình Firebase Console
- Đi tới https://console.firebase.google.com/
- Chọn project của bạn
- Vào Authentication > Sign-in method
- Enable Google Sign-in
- Thêm authorized domains nếu cần

### 2. Cấu hình iOS (nếu chạy trên iOS)
- Mở `ios/Runner.xcworkspace` trong Xcode
- Thêm URL scheme vào Info.plist:
  - Vào Runner > Info.plist
  - Thêm key `CFBundleURLTypes` nếu chưa có
  - Thêm REVERSED_CLIENT_ID từ GoogleService-Info.plist

### 3. Cấu hình Android (đã có sẵn)
- File `google-services.json` đã có trong `android/app/`
- Plugin Google Services đã được thêm vào build.gradle

### 4. Test Google Sign-In
```bash
# Chạy trên Android emulator hoặc device
flutter run -d android

# Chạy trên iOS simulator hoặc device  
flutter run -d ios

# Chạy trên web (cần cấu hình thêm)
flutter run -d chrome
```

## Features đã implement:

### AuthService (`lib/services/auth_service.dart`)
- `signInWithGoogle()`: Đăng nhập với Google
- `signOut()`: Đăng xuất
- `isSignedIn()`: Kiểm tra trạng thái đăng nhập
- `getUserDisplayName()`, `getUserEmail()`, `getUserPhotoURL()`: Lấy thông tin user

### AuthState (`lib/auth_state.dart`)
- Quản lý state authentication
- Lắng nghe thay đổi trạng thái từ Firebase
- Loading state cho UI
- Backward compatibility với code cũ

### LoginPage (`lib/pages/login_page.dart`)
- UI đẹp cho trang login
- Google Sign-In button với loading state
- Responsive design

### DashboardLayout (`lib/layout/dashboard_layout.dart`)
- Hiển thị thông tin user trong AppBar và Drawer
- Avatar user từ Google account
- Logout functionality

## Cách sử dụng:

```dart
// Đăng nhập
final authState = context.read<AuthState>();
await authState.signInWithGoogle();

// Đăng xuất
await authState.signOut();

// Kiểm tra trạng thái
if (authState.isLoggedIn) {
  // User đã đăng nhập
  final user = authState.user;
  print('Hello ${user?.displayName}');
}
```

## Lưu ý:
- Cần có internet để Google Sign-In hoạt động
- Trên emulator Android, cần có Google Play Services
- Trên iOS simulator, cần setup URL scheme
- Web cần cấu hình authorized JavaScript origins trong Firebase Console
