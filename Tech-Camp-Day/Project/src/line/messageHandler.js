const { createUser, deleteUser } = require("../data/db");
const { reply } = require("./messageSender");

/**
 * จัดการกับเหตุการณ์ที่เข้ามา, ตรวจสอบประเภทของเหตุการณ์และส่งไปยังฟังก์ชันที่เหมาะสม
 * @param {object} event - อ็อบเจ็กต์เหตุการณ์
 */
function handleEvent(event) {
  switch (event.type) {
    case "message":
      handleMessage(event);
      break;
    case "follow":
      handleFollow(event);
      break;
    case "unfollow":
      handleUnfollow(event);
      break;
    default:
      break;
  }
}

/**
 * จัดการกับเหตุการณ์ 'follow' ส่งข้อความทักทายและสร้างผู้ใช้ในฐานข้อมูล
 * @param {object} event - อ็อบเจ็กต์เหตุการณ์
 */
function handleFollow(event) {
  reply(event, "สวัสดีครับ นี่คือบอตเปล่าๆ ไม่มีอะไรเลย");
  createUser(event.source.userId);
}

/**
 * จัดการกับเหตุการณ์ 'unfollow' ลบผู้ใช้ออกจากฐานข้อมูล
 * @param {object} event - อ็อบเจ็กต์เหตุการณ์
 */
function handleUnfollow(event) {
  deleteUser(event.source.userId);
}

/**
 * จัดการกับเหตุการณ์ข้อความที่เข้ามา พิมพ์อะไรตอบแบบนั้น
 * @param {object} event - อ็อบเจ็กต์เหตุการณ์ข้อความ
 */
function handleMessage(event) {
  if (event.type !== "message" || event.message.type !== "text") {
    return;
  }

  reply(event, event.message.text);
}

module.exports = { handleEvent };
