# 🎓 กิจกรรมพี่สอนน้อง 2026 (Senior Teaching Junior)

> **"อบรมเชิงปฏิบัติการ เพื่อส่งเสริมทักษะการเลือกใช้เครื่องมือและพัฒนาแอปพลิเคชันอย่างมืออาชีพ"**

## 📅 รายละเอียดกิจกรรม

| รายละเอียด | ข้อมูล |
|------------|--------|
| 📆 วันที่ | 23–27 ก.พ. 2569 และ 2–6 มี.ค. 2569 (รวม 10 วัน) |
| 🕘 เวลา | 09:00 – 16:00 น. |
| 📍 สถานที่ | ห้อง Sci9-301 ชั้น 3 ภาควิชาคอมพิวเตอร์ คณะวิทยาศาสตร์และเทคโนโลยี มรภ.เชียงใหม่ (ศูนย์แม่ริม) |
| 💰 ค่าใช้จ่าย | **ฟรี!** ไม่มีค่าใช้จ่าย |
| 👥 รับสมัคร | 40 คน เท่านั้น |

---

## 📚 หัวข้อการอบรม

| # | หัวข้อ | เครื่องมือ |
|---|--------|-----------|
| 1 | 🌐 **Web Development** | Laravel 12 / Livewire 3 / Flux UI / Tailwind CSS v4 + AI Coder Generator |
| 2 | 📱 **Mobile Development** | Flutter + Firebase / Cloud |
| 3 | 🎨 **UI/UX Design** | Figma (พื้นฐาน → Prototype) |

---

## 👨‍🏫 วิทยากร

- **วิทยากร**: Tanonchai รุ่นพี่รหัส 65 Computer Science [Tanonchai67](https://github.com/Tanonchai67)
- **วิทยากร**: Kritsanai (รุ่นพี่รหัส 65 Web Technology) — [NightBrain](https://github.com/NightBrain)

---

## 🎁 สิทธิประโยชน์

- ✅ ได้รับ**หน่วยกิจกรรมภาคบังคับ**
- ✅ ได้รับ**เกียรติบัตร**เมื่อผ่านการอบรมครบตามกำหนด

---

## 📂 โปรเจกต์ในหลักสูตร Mobile Development

### 📱 [Flutter Firebase Login](./flutter_firebase_login/)
> อบรมวันที่ **23-27 ก.พ. 2569**

> ระบบแอปมือถือสำหรับ Login และจัดการสินค้า ด้วย Flutter + Firebase + Cloudinary

| Feature | รายละเอียด |
|---------|-----------|
| 🔐 Login / Register | Firebase Authentication (Email/Password) |
| 🏠 Home | ดูสินค้าทั้งหมด Real-time + ระบบค้นหา |
| 🛒 สินค้าของฉัน | จัดการสินค้าที่ตัวเองลงขาย |
| ➕ เพิ่ม / ✏️ แก้ไข | อัปโหลดรูปภาพผ่าน Cloudinary |
| 👤 โปรไฟล์ | แก้ไขข้อมูลส่วนตัว |

**Tech Stack:** Flutter · Firebase Auth · Cloud Firestore · Cloudinary · image_picker

---

## 🎓 ระบบจัดการเวิร์กชอป (Workshop Management System)

> 🔗 **Source Code (GitHub Organization):** [Workshop-std66143420](https://github.com/Department-of-Computer-CMRU-2026/Workshop-std66143420)

> อบรมวันที่ **2-6 มีนาคม 2569**

> ระบบลงทะเบียนและจัดการกิจกรรมเวิร์กชอป พัฒนาด้วย **Laravel 12** ร่วมกับ **Livewire 3** และออกแบบ UI ให้มีความสวยงามทันสมัยสไตล์ Glassmorphism ด้วย Flux UI และ Tailwind CSS v4

---

### ✨ ฟีเจอร์หลัก (Features)

#### 🧑‍🎓 สำหรับนักศึกษา (Student Panel)
- **ลงทะเบียนเข้าร่วมเวิร์กชอป**: เลือกหัวข้อที่สนใจได้ สูงสุด **3 หัวข้อ** ต่อคน
- **ป้องกันลงทะเบียนซ้ำ**: ระบบตรวจสอบและปฏิเสธ Double Registration
- **ที่นั่งแบบ Real-time**: ระบบปิดรับสมัครอัตโนมัติเมื่อที่นั่งเต็ม
- **เวิร์กชอปของฉัน**: ดูกิจกรรมที่ลงทะเบียนไว้แล้ว และยกเลิกได้ (พร้อม Confirmation)
- **โปรไฟล์**: แสดงรูปภาพอัตโนมัติจาก CMRU API โดยใช้ `student_id`

#### 👨‍💼 สำหรับผู้ดูแลระบบ (Admin Panel)
- **จัดการเวิร์กชอป (CRUD)**: สร้าง แก้ไข ดู และลบเวิร์กชอปได้
- **Dashboard**: ภาพรวมกิจกรรม จำนวนผู้ลงทะเบียน และที่นั่งคงเหลือ
- **ยืนยันก่อนดำเนินการ**: ป้องกันกดผิดพลาดด้วย SweetAlert2

---

### 🛠️ เทคโนโลยีที่ใช้ (Tech Stack)

| Layer | Technology |
|:------|:-----------|
| Backend | Laravel 12, PHP 8.4+ |
| Frontend | Livewire 3, Flux UI, Tailwind CSS v4 |
| Database | PostgreSQL 16 |
| Container | Docker, Docker Compose |
| CI/CD | GitHub Actions (Self-hosted Runner) |
| JS Runtime | Bun (สำหรับ build assets ใน Container) |
| Alerts | SweetAlert2 |

---


> *พัฒนาเพื่อประกอบการอบรม — Department of Computer Science, CMRU 2026*
