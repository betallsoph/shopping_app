# Hướng dẫn Setup Firebase Project Mới

## Bước 1: Tạo Firebase Project

1. Đi tới https://console.firebase.google.com/
2. Nhấp "Create a project" hoặc "Add project"
3. Đặt tên project: `shopping-admin-flutter` (hoặc tên bạn muốn)
4. Có thể disable Google Analytics nếu không cần
5. Nhấp "Create project"

## Bước 2: Enable Authentication với Google

1. Trong Firebase Console, vào "Authentication"
2. Nhấp "Get started" nếu lần đầu
3. Chọn tab "Sign-in method"
4. Tìm "Google" và nhấp "Enable"
5. Chọn support email và nhấp "Save"

## Bước 3: Login Firebase CLI và Configure FlutterFire

Chạy các lệnh sau trong terminal:

```bash
# Login vào Firebase
firebase login

# Configure FlutterFire
flutterfire configure
```

Khi chạy `flutterfire configure`:
- Chọn project vừa tạo
- Chọn platforms muốn support (iOS, Android, Web, macOS)
- Tool sẽ tự động tạo firebase_options.dart

## Bước 4: Cấu hình thêm cho từng platform

### Android:
- File `google-services.json` sẽ được tự động tải về
- Đã có sẵn plugin trong `android/app/build.gradle.kts`

### iOS:
- File `GoogleService-Info.plist` sẽ được tải về
- Cần thêm URL Scheme vào Info.plist

### Web:
- Cần config authorized domains trong Firebase Console

## Bước 5: Test

```bash
flutter run
```

## Ghi chú:
- Firebase CLI và FlutterFire CLI đã được cài đặt
- Code đã sẵn sàng, chỉ cần configure project mới
- Sau khi chạy `flutterfire configure`, app sẽ hoạt động ngay
