require("dotenv").config();
const express = require("express");
const { router: memberRouter } = require("./webhooks/member");
const merchantRouter = require("./webhooks/merchant");

// สร้่าง express app
const app = express();

/**
 * กำหนดให้ ถ้ามี request เข้ามาที่ /webhooks/member
 * ให้ใช้ memberRouter ในการจัดการ
 *
 * และถ้ามี request เข้ามาที่ /webhooks/merchant
 * ให้ใช้ merchantRouter ในการจัดการ
 */
app.use("/webhooks/member", memberRouter);
app.use("/webhooks/merchant", merchantRouter);

// กำหนดให้ app รันบน port 3000
app.listen(3000);
