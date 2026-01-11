const express = require("express");
const line = require("@line/bot-sdk");
const { insertMember, deleteMember, getMemberByUid } = require("../persists");
const { replier, pusher } = require("./util");

const memberConfig = {
  channelSecret: process.env.MEMBER_CHANNEL_SECRET,
  channelAccessToken: process.env.MEMBER_CHANNEL_ACCESS_TOKEN,
};

const memberWebhookMiddleware = line.middleware(memberConfig);
const memberClient = new line.messagingApi.MessagingApiClient(memberConfig);
const replyToMember = replier(memberClient);
const pushToMember = pusher(memberClient);

const router = express.Router();

router.post("/", memberWebhookMiddleware, handlePostRequest);

/**
 * จัดการ request ที่เข้ามาที่ /webhooks/member
 * @param {Object} request - คำขอที่เข้ามา
 * @param {Object} response - การตอบกลับของคำขอ
 * @returns {Promise} - ส่งผลจากการจัดการ event กลับไป
 */
async function handlePostRequest(request, response) {
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
    case "follow":
      return handleFollowEvent(event);
    case "unfollow":
      return handleUnfollowEvent(event);
    case "message":
      return handleMessageEvent(event);
    default:
      return handleUnknownEvent(event);
  }
}

function handleFollowEvent(event) {
  const userId = event.source.userId;

  insertMember(userId);
  pushToMember(
    userId,
    "ยินดีต้อนรับเข้าสู่ สมาชิก Bot ครับ กรุณาพิมพ์ 'เช็คคะแนน' เพื่อเช็คคะแนนของคุณ"
  );
}

function handleUnfollowEvent(event) {
  const userId = event.source.userId;

  deleteMember(userId);
}

function handleMessageEvent(event) {
  const text = event.message.text;

  if (text === "เช็คคะแนน") {
    const member = getMemberByUid(event.source.userId);
    return replyToMember(event, `คุณมีคะแนนสะสม ${member.points} คะแนน`);
  }
}

function handleUnknownEvent(event) {
  return replyToMember(event, "ขอโทษครับ ฉันไม่เข้าใจคำสั่งของคุณ");
}

module.exports = {
  router,
  pushToMember,
};
