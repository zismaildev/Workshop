const db = require("better-sqlite3")("database.db", {
  verbose: console.log,
});

/**
 * กำหนดค่าเริ่มต้นให้ฐานข้อมูลโดยการสร้างตารางที่จำเป็นหากยังไม่มีอยู่
 */
const initDb = () => {
  const createUserTable = db.prepare(`
    create table if not exists users (
      lineUserId text primary key
    )
  `);

  const createAllTables = db.transaction(() => {
    createUserTable.run();
  });

  createAllTables();
};

initDb();

/**
 * สร้างผู้ใช้ใหม่ในฐานข้อมูล
 * @param {string} lineUserId - ไอดีผู้ใช้ของ Line
 */
function createUser(lineUserId) {
  const insertUser = db.prepare("insert into users (lineUserId) values (?)");
  insertUser.run(lineUserId);
}

/**
 * ลบผู้ใช้ออกจากฐานข้อมูล
 * @param {string} lineUserId - ไอดีผู้ใช้ของ Line
 */
function deleteUser(lineUserId) {
  const deleteUser = db.prepare("delete from users where lineUserId = ?");

  db.transaction(() => {
    deleteUser.run(lineUserId);
  })();
}

module.exports = { createUser, deleteUser };
