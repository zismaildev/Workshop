const line = require("@line/bot-sdk");
const express = require("express");
require("dotenv").config();
const fortunes = require("./fortune.json");

const lineConfig = {
  channelSecret: process.env.LINE_CHANNEL_SECRET,
  channelAccessToken: process.env.LINE_CHANNEL_ACCESS_TOKEN,
};

const messagingClient = new line.messagingApi.MessagingApiClient(lineConfig);

const app = express();
app.post("/", line.middleware(lineConfig), handlePostRequest);
app.listen(3000);

async function handlePostRequest(req, res) {
  const { events } = req.body;

  const eventHandledPromises = events.map(handleLineEvent);

  const result = await Promise.all(eventHandledPromises);

  return res.send(result);
}

function reply(event, ...messages) {
  return messagingClient.replyMessage({
    replyToken: event.replyToken,
    messages: messages.map((message) => ({
      type: "text",
      text: message,
    })),
  });
}

function handleLineEvent(event) {
  // หยิบเอา text จาก message ใน event ออกมา
  const text = event.message.text;

  if (text === "ดูดวง") {
    return reply(event, ...getAllFortuneMessages());
  } else {
    return reply(event, "???"); // << ใส่ข้อความตรง ???
  }
}

const FortuneCategory = {
  Love: "love",
  Career: "career",
  Finance: "finance",
  Health: "health",
};

function getFortune(category) {
  const index = Math.floor(Math.random() * fortunes[category].length);
  return fortunes[category][index];
}

let count = 1;

function getAllFortuneMessages() {
  const fortuneMessages = [
    `ดูดวงประจำวันครั้งที่ ${count++}`,
    `ด้านความรัก\n${getFortune(FortuneCategory.Love)}`,
    `ด้านการงาน\n${getFortune(FortuneCategory.Career)}`,
    `ด้านการเงิน\n${getFortune(FortuneCategory.Finance)}`,
    `ด้านสุขภาพ\n${getFortune(FortuneCategory.Health)}`,
  ];

  return fortuneMessages;
}
