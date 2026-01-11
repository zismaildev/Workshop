const db = require("better-sqlite3")("kakekikoku.db", { verbose: console.log });

/**
 * ฟังก์ชันสำหรับเริ่มต้นฐานข้อมูล
 */
const initDb = () => {
  const createMembersTable = db.prepare(`
        CREATE TABLE IF NOT EXISTS members (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uid VARCHAR(255) NOT NULL UNIQUE,
            points INT NOT NULL DEFAULT 0
        )
    `);

  db.transaction(() => {
    createMembersTable.run();
  })();
};

initDb();

/**
 * ดึงข้อมูลสมาชิกทั้งหมด
 *
 * @returns {Array} ข้อมูลสมาชิกทั้งหมด
 */
const getAllMembers = () =>
  db.prepare("SELECT id, points FROM members").all() ?? [];

/**
 * ดึงข้อมูลสมาชิกตาม ID
 *
 * @param {number} id ไอดีของสมาชิก
 * @returns {Object} ข้อมูลสมาชิกที่ตรงกับ ID ที่กำหนด
 */
const getMemberById = (id) =>
  db.prepare("SELECT id, uid, points FROM members WHERE id = ?").get(id);

/**
 * ดึงข้อมูลสมาชิกตาม UID
 *
 * @param {string} uid UID ของสมาชิก
 * @returns {Object} ข้อมูลสมาชิกที่ตรงกับ UID ที่กำหนด
 */
const getMemberByUid = (uid) =>
  db.prepare("SELECT id, uid, points FROM members WHERE uid = ?").get(uid);

/**
 * เพิ่มสมาชิกใหม่
 *
 * @param {string} uid UID ของสมาชิกใหม่
 */
const insertMember = (uid) => {
  const insertStatement = db.prepare(
    `INSERT INTO members (uid) VALUES (?) ON CONFLICT DO NOTHING`
  );

  try {
    insertStatement.run(uid);
  } catch (e) {
    console.error(`Cannot insert member`, e);
    throw e;
  }
};

/**
 * ลบสมาชิกตาม ID
 *
 * @param {number} id ไอดีของสมาชิกที่ต้องการลบ
 */
const deleteMember = (id) => {
  const deleteStatement = db.prepare(`DELETE FROM members WHERE id = ?`);
  try {
    deleteStatement.run(id);
  } catch (e) {
    console.error(`Cannot delete member`, e);
    throw e;
  }
};

/**
 * อัปเดตคะแนนสำหรับสมาชิกที่กำหนด
 *
 * @param {number} id ไอดีของสมาชิก
 * @param {number} points คะแนนที่ต้องการอัปเดต
 */
const updatePointForMember = (id, points) => {
  const updateStatement = db.prepare(
    `UPDATE members SET points = ? where id = ?`
  );

  try {
    updateStatement.run(points, id);
  } catch (e) {
    console.error(`Cannot update points`, e);
    throw e;
  }
};

module.exports = {
  getAllMembers,
  getMemberById,
  getMemberByUid,
  insertMember,
  deleteMember,
  updatePointForMember,
};
