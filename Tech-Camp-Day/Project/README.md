# LINE Bot Template (Project)

โปรเจกต์ตั้งต้น (Starter Kit) สำหรับการสร้าง LINE Bot ด้วย Node.js และ Express เหมาะสำหรับนำไปต่อยอดเป็นโปรเจกต์ใหม่

## ฟีเจอร์ปัจจุบัน
- **Echo Bot**: ตอบกลับข้อความด้วยข้อความเดิมที่ผู้ใช้ส่งมา
- **Greeting**: ทักทายผู้ใช้เมื่อมีการกด Follow (`สวัสดีครับ นี่คือบอตเปล่าๆ ไม่มีอะไรเลย`)
- **Database Ready**: มีโครงสร้าง `data/db.js` เตรียมไว้สำหรับเชื่อมต่อฐานข้อมูล

## โครงสร้างโปรเจกต์
- `src/index.js`: Entry point ของโปรแกรม
- `src/routes/line-webhook.js`: Route หลักสำหรับรับ Webhook จาก LINE
- `src/line/messageHandler.js`: Logic การจัดการ Event ต่างๆ (Message, Follow, Unfollow)

## การนำไปใช้งานต่อ
1. แก้ไข Logic ใน `src/line/messageHandler.js` เพื่อเพิ่มฟีเจอร์ที่ต้องการ
2. ตั้งค่า `.env` ให้เรียบร้อย
3. รันโปรเจกต์ด้วย `npm start`
