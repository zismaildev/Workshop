const {
  createUser,
  deleteUser,
  saveTransaction,
  getReport,
} = require("../data/db");
const { reply } = require("./messageSender");

const howTo = `วิธีใช้บอท
1. พิมพ์ "จด" ตามด้วยชื่อรายการและจำนวนเงินที่จ่ายไป เช่น "จด อาหาร 100" หรือ "จด ขนม ของใช้ 500"
2. พิมพ์ "รายงาน" ตามด้วยจำนวนวันที่ต้องการดูย้อนหลังและช่วงเวลาที่ต้องการดูย้อนหลัง เช่น "รายงาน 7 วัน" หรือ "รายงาน 1 เดือน"`;

const intervalTypes = ["วัน", "เดือน", "ปี"];

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
  reply(event, "สวัสดีครับ ให้ผมช่วยจดรายจ่ายให้คุณนะครับ", howTo);
  createUser(event.source.userId);
}

/**
 * จัดการกับเหตุการณ์ 'unfollow' ลบผู้ใช้และรายการจดรายจ่ายออกจากฐานข้อมูล
 * @param {object} event - อ็อบเจ็กต์เหตุการณ์
 */
function handleUnfollow(event) {
  deleteUser(event.source.userId);
}

/**
 * จัดการกับเหตุการณ์ข้อความที่เข้ามา ตรวจสอบคำสั่งและส่งไปยังฟังก์ชันที่เหมาะสม
 * @param {object} event - อ็อบเจ็กต์เหตุการณ์ข้อความ
 */
function handleMessage(event) {
  if (event.type !== "message" || event.message.type !== "text") {
    return;
  }

  const [command] = event.message.text.split(" ");

  switch (command) {
    case "จด":
      handleSave(event);
      return;
    case "รายงาน":
      handleReport(event);
      return;
    default:
      reply(event, "ไม่เข้าใจคำสั่งจ้า", howTo);
      return;
  }
}

/**
 * จัดการคำสั่ง "จด" โดยแยกชื่อและจำนวนเงินจากข้อความที่กำหนดและบันทึกธุรกรรม
 * @param {object} event - อ็อบเจ็กต์เหตุการณ์
 */
function handleSave(event) {
  const words = event.message.text.split(" ");
  const transactionName = words.slice(1, -1).join(" ");
  const amount = words.pop();
  const amountNumber = parseFloat(amount);

  const lineUserId = event.source.userId;

  if (isNaN(amountNumber)) {
    reply(event, "จำนวนเงินไม่ถูกต้อง");
    return;
  }

  try {
    saveTransaction(lineUserId, transactionName, amountNumber);
    reply(event, "บันทึกข้อมูลเรียบร้อย");
  } catch (error) {
    reply(event, "เกิดข้อผิดพลาดในการบันทึกข้อมูล");
  }
}

/**
 * จัดการคำสั่ง "รายงาน" และสร้างรายงานของธุรกรรมตามพารามิเตอร์ที่กำหนด
 * @param {Object} event - อ็อบเจ็กต์เหตุการณ์ที่มีข้อความและข้อมูลต้นทาง
 */
function handleReport(event) {
  const words = event.message.text.split(" ");
  const length = Number.parseInt(words[1]);
  const interval = words[2];
  const lineUserId = event.source.userId;

  if (words.length !== 3) {
    reply(event, "คำสั่งไม่ถูกต้อง", howTo);
    return;
  }

  if (isNaN(length) || length < 1) {
    reply(event, "ระยะเวลาไม่ถูกต้อง ระบุเป็นจำนวนเต็มบวกได้เท่านั้น");
    return;
  }

  if (!intervalTypes.includes(interval)) {
    reply(
      event,
      'ช่วงเวลาไม่ถูกต้อง ระบุเป็น "วัน", "เดือน", หรือ "ปี" ได้เท่านั้น',
    );
    return;
  }

  let intervalDbType;
  if (interval === "วัน") {
    intervalDbType = "days";
  } else if (interval === "เดือน") {
    intervalDbType = "months";
  } else {
    intervalDbType = "years";
  }

  const { transactions, totalAmount } = getReport(
    lineUserId,
    length,
    intervalDbType,
  );

  let message = `รายงานธุรกรรมย้อนหลัง ${length} ${interval} ที่ผ่านมา
  จำนวนธุรกรรม: ${transactions}
  ยอดเงินรวม: ${totalAmount} บาท`;

  reply(event, message);
}

module.exports = { handleEvent };
