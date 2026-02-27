[← กลับไปหน้า กิจกรรมพี่สอนน้อง 2026](../README.md)

# 📱 Flutter Firebase Login

> **โปรเจคตัวอย่างสำหรับกิจกรรม "พี่สอนน้อง 2026"**  
> ระบบแอปมือถือสำหรับ Login และจัดการสินค้า ด้วย Flutter + Firebase + Cloudinary

---

## ✨ Features

| หน้า | ความสามารถ |
|------|-----------|
| 🔐 Login | เข้าสู่ระบบด้วย Email/Password |
| 📝 Register | สมัครสมาชิกใหม่ |
| 🏠 Home | ดูสินค้าทั้งหมดแบบ Real-time + ค้นหาสินค้า |
| 🛒 สินค้าของฉัน | ดูและลบสินค้าที่ตัวเองลงขาย |
| ➕ เพิ่มสินค้า | อัปโหลดรูป + บันทึกลง Firestore |
| ✏️ แก้ไขสินค้า | แก้ไขชื่อ ราคา และรูปภาพสินค้า |
| 👤 โปรไฟล์ | แก้ไขชื่อ อายุ และเพศ |

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **Auth**: Firebase Authentication (Email/Password)
- **Database**: Cloud Firestore (Real-time NoSQL)
- **Image Storage**: [Cloudinary](https://cloudinary.com/) (อัปโหลดรูปภาพ)
- **Packages**: `image_picker`, `http`

---

## 📂 Project Structure

```
flutter_firebase_login/
├── assets/
│   └── images/
│       └── logo.png              # โลโก้แอป
├── lib/
│   ├── page/
│   │   ├── login_page.dart       # หน้าเข้าสู่ระบบ
│   │   ├── register_page.dart    # หน้าสมัครสมาชิก
│   │   ├── home_page.dart        # หน้าหลัก (สินค้าทั้งหมด + ค้นหา)
│   │   ├── productdetail_page.dart # สินค้าของฉัน (ลบได้)
│   │   ├── addproduct.dart       # หน้าเพิ่มสินค้า
│   │   ├── editproduct.dart      # หน้าแก้ไขสินค้า
│   │   └── profile_page.dart     # หน้าโปรไฟล์ผู้ใช้
│   ├── firebase_options.dart     # Auto-generated Firebase config
│   └── main.dart                 # Entry point
├── firebase.json.example         # ตัวอย่าง firebase.json
├── pubspec.yaml
└── Firebase Console.pdf          # เอกสารประกอบการสอน
```

---

## 🗄️ Firestore Collections

### `products` — ข้อมูลสินค้า
| Field | Type | ตัวอย่าง |
|-------|------|---------|
| `name` | String | `"กาแฟอเมริกาโน่"` |
| `price` | Number | `65` |
| `imageUrl` | String | `"https://res.cloudinary.com/..."` |
| `sellerEmail` | String | `"seller@email.com"` |
| `createdAt` | Timestamp | — |
| `updatedAt` | Timestamp | — |

### `users` — ข้อมูลผู้ใช้
| Field | Type | ตัวอย่าง |
|-------|------|---------|
| `name` | String | `"สมชาย ใจดี"` |
| `age` | Number | `20` |
| `gender` | String | `"ชาย"` |

---

## 🚀 Getting Started

### 1. ติดตั้ง Dependencies

```bash
flutter pub get
```

---

### 2. ตรวจสอบ flutterfire CLI

```bash
# เช็คว่าติดตั้ง flutterfire อยู่หรือยัง
where.exe flutterfire
```

> หากไม่พบให้เพิ่ม path นี้เข้า Environment Variables:
> ```
> %USERPROFILE%\AppData\Local\Pub\Cache\bin
> ```

---

### 3. Login Firebase

```bash
# ดูว่า Login อยู่กับ account ไหน
firebase login:list

# Login เข้าระบบ
firebase login

# Logout (ถ้าต้องการเปลี่ยน account)
firebase logout
```

---

### 4. เพิ่ม Firebase Packages

```bash
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore
flutter pub add image_picker
flutter pub add http
```

> [!NOTE]
> - **firebase_core** — บังคับต้องมีก่อนใช้ Firebase service ใดๆ
> - **firebase_auth** — จัดการระบบ Login / สมาชิก
> - **cloud_firestore** — ฐานข้อมูล NoSQL แบบ Real-time
> - **image_picker** — เลือกรูปจาก Gallery หรือ Camera
> - **http** — เรียก API / ส่งข้อมูลไปภายนอก (ใช้กับ Cloudinary)

---

### 5. เชื่อมแอปกับ Firebase Project

```bash
flutterfire configure
```

เลือก Firebase Project และ Platform ที่ต้องการ (Android / iOS) คำสั่งนี้จะสร้างไฟล์ `firebase_options.dart` ให้อัตโนมัติ

---

### 6. ตั้งค่า Android (`build.gradle`)

เปิดไฟล์ `android/app/build.gradle` แล้วแก้ `minSdk` เป็น `23`:

```gradle
defaultConfig {
    applicationId = "com.example.flutter_firebase_login"
    minSdk = 23   // ← ต้องเป็น 23 ขึ้นไป เพื่อรองรับ Firebase plugins
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
}
```

> [!IMPORTANT]
> หาก `minSdk` ต่ำกว่า 23 จะเกิด error ตอน build บน Android

---

### 7. เปิดใช้งาน Authentication บน Firebase Console

1. ไปที่ [Firebase Console](https://console.firebase.google.com/)
2. เลือกโปรเจกต์ของคุณ
3. เมนูด้านซ้าย → **Authentication** → **Sign-in method**
4. เปิดใช้งาน **Email/Password** → Save

> [!WARNING]
> ถ้าไม่เปิด Email/Password ใน Console จะเกิด error ทุกครั้งที่พยายาม Login หรือสมัครสมาชิก

---

### 8. ตั้งค่าโค้ดเริ่มต้น (`main.dart`)

```dart
void main() async {
  // 1. บังคับใส่บรรทัดนี้ทุกครั้งที่ใช้ async ใน main
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase ก่อน runApp เสมอ
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
```

---

### 9. ตั้งค่า Cloudinary ☁️

Cloudinary ใช้สำหรับ**อัปโหลดและเก็บรูปภาพ**สินค้าในโปรเจกต์นี้

1. สมัครบัญชีฟรีที่ [console.cloudinary.com](https://console.cloudinary.com/)
2. ดู **Cloud Name** ได้จากหน้า Dashboard (มุมบนซ้าย)
3. สร้าง **Upload Preset**:
   - ไปที่ **Settings → Upload → Upload presets**
   - กด Add upload preset
   - ตั้ง **Signing Mode = `Unsigned`** ← สำคัญมาก!
   - บันทึกชื่อ Preset ไว้

เปิดไฟล์ `lib/page/addproduct.dart` และ `lib/page/editproduct.dart` แล้วแก้ค่า:

```dart
// ⚠️ เปลี่ยนเป็นค่าของคุณเอง
final String cloudName = 'YOUR_CLOUD_NAME';     // จาก Cloudinary Dashboard
final String uploadPreset = 'YOUR_PRESET_NAME'; // ชื่อ Preset ที่สร้าง (Unsigned)
```

**ตัวอย่าง (ของโปรเจกต์นี้):**
```dart
final String cloudName = 'dkhde93ml';
final String uploadPreset = 'Moblie-App';
```

> [!CAUTION]
> ไม่ควร Commit ค่าจริงขึ้น GitHub สาธารณะ ให้เปลี่ยนเป็นค่าของตัวเองก่อน Push

---

### 10. ใส่ Logo

วางไฟล์รูปโลโก้ไว้ที่:
```
assets/images/logo.png
```

---

### 11. รันแอป

```bash
flutter run
```

---

### 12. (เสริม) เปลี่ยนไอคอนแอป

```bash
# เพิ่ม package
dart pub add flutter_launcher_icons

# สั่งสร้างไอคอนใหม่
flutter pub run flutter_launcher_icons
```

### 13. (เสริม) เปลี่ยนชื่อแอป

เปิดไฟล์ `android/app/src/main/AndroidManifest.xml` แล้วแก้:

```xml
android:label="ชื่อแอปของคุณ"
```

### 14. (เสริม) Build APK

```bash
flutter build apk
```

สร้างไฟล์ `.apk` สำหรับติดตั้งบน Android



---

## 📦 Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  firebase_core: ^4.4.0
  firebase_auth: ^6.1.4
  cloud_firestore: ^6.1.2
  image_picker: ^1.2.1
  http: ^1.6.0
```

---

## 🔄 App Flow

```
เปิดแอป
   └── Login Page
         ├── [ล็อกอินสำเร็จ] → Home Page
         │        ├── ดูสินค้าทั้งหมด (Real-time)
         │        ├── ค้นหาสินค้า
         │        └── [FAB] → สินค้าของฉัน
         │                    ├── ลบสินค้า
         │                    ├── [กดรายการ] → แก้ไขสินค้า
         │                    └── [FAB] → เพิ่มสินค้าใหม่
         └── [ยังไม่มีบัญชี] → Register Page
```

---

## 👨‍🏫 เอกสารอ้างอิง

- [Flutter Docs](https://docs.flutter.dev/)
- [Firebase Auth](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Cloudinary Upload API](https://cloudinary.com/documentation/image_upload_api_reference)
- [image_picker](https://pub.dev/packages/image_picker)

---

> *กิจกรรมพี่สอนน้อง 2026 — ภาควิชาคอมพิวเตอร์ คณะวิทยาศาสตร์และเทคโนโลยี มหาวิทยาลัยราชภัฏเชียงใหม่*
