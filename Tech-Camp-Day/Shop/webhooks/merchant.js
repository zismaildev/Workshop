const express = require("express");
const line = require("@line/bot-sdk");
const {
  getMemberById,
  getAllMembers,
  updatePointForMember,
  getMemberByUid,
} = require("../persists");
const { replier } = require("./util");
const { pushToMember } = require("./member");

const merchantConfig = {
  channelSecret: process.env.MERCHANT_CHANNEL_SECRET,
  channelAccessToken: process.env.MERCHANT_CHANNEL_ACCESS_TOKEN,
};

const merchantWebhookMiddleware = line.middleware(merchantConfig);
const merchantClient = new line.messagingApi.MessagingApiClient(merchantConfig);
const replyToMerchant = replier(merchantClient);

const router = express.Router();

router.post("/", merchantWebhookMiddleware, handleRequest);

/**
 * จัดการ request ที่เข้ามาที่ /webhooks/member
 * @param {Object} request - คำขอที่เข้ามา
 * @param {Object} response - การตอบกลับของคำขอ
 * @returns {Promise} - ส่งผลจากการจัดการ event กลับไป
 */
async function handleRequest(request, response) {
  // หยิบ events ออกมาจาก request body
  const { events } = request.body;

  // วนเรียกฟังก์ชัน handleLineEvent ที่ event แต่ละตัว
  const eventHandledPromises = events.map(handleLineEvent);

  // รอให้ event ทั้งหมดถูกจัดการ
  const result = await Promise.all(eventHandledPromises);

  // ส่งผลจากการจัดการ event กลับไป
  return response.send(result);
}

function handleLineEvent(event) {
  switch (event.type) {
    case "message":
      return handleMessageEvent(event);
    default:
      return handleUnknownEvent(event);
  }
}

function handleMessageEvent(event) {
  const text = event.message.text;

  if (text === "จัดการสมาชิก") {
    const members = getAllMembers();
    const memberInfoMessages = members.map(
      (member) => `สมาชิกหมายเลข ${member.id} มีคะแนน ${member.points} คะแนน`
    );

    return replyToMerchant(event, ...memberInfoMessages);
  }

  if (text.includes("เพิ่มคะแนน")) {
    return handlePointIncrease(event, text);
  }

  return replyToMerchant(
    event,
    "กรุณาพิมพ์ 'จัดการสมาชิก' เพื่อดูข้อมูลสมาชิก เพื่อเพิ่มคะแนนให้สมาชิก",
    "หรือพิมพ์ 'เพิ่มคะแนน <รหัสสมาชิก> <คะแนน>' เพื่อเพิ่มคะแนนของสมาชิก"
  );
}

/**
 * จัดการ event ที่ไม่รู้จัก
 * @param {Object} event - event ที่จะถูกจัดการ
 */

function handlePointIncrease(event, text) {
  const [_, memberId, pointToAddText] = text.split(" ");

  const member = getMemberById(memberId);

  if (!member) {
    return replyToMerchant(event, `ไม่พบสมาชิกหมายเลข ${memberId}`);
  }

  const pointToAdd = parseInt(pointToAddText);

  if (isNaN(pointToAdd)) {
    return replyToMerchant(
      event,
      "กรุณาใส่จำนวนคะแนนที่ต้องการเพิ่มเป็นตัวเลขเท่านั้น"
    );
  }

  updatePointForMember(memberId, member.points + pointToAdd);
  pushToMember(member.uid, `คุณได้รับคะแนน ${pointToAdd} คะแนน`);

  return replyToMerchant(
    event,
    `เพิ่มคะแนน ${pointToAdd} คะแนนให้สมาชิกหมายเลข ${memberId} แล้ว`
  );
}

function handleUnknownEvent(event) {
  return replyToMerchant(event, "ขอโทษครับ ฉันไม่เข้าใจคำสั่งของคุณ");
}

module.exports = router;
