const db = require("better-sqlite3")("expense-memo.db", {
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

  const createTransactionTable = db.prepare(`
    create table if not exists transactions (
      id integer primary key autoincrement,
      lineUserId text not null,
      name varchar not null,
      amount float not null,
      date timestamp default current_timestamp not null,
      foreign key (lineUserId) references users(lineUserId)
    )
  `);

  const createAllTables = db.transaction(() => {
    createUserTable.run();
    createTransactionTable.run();
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
 * ลบผู้ใช้และประวัติการใช้งานของพวกเขาออกจากฐานข้อมูล
 * @param {string} lineUserId - ไอดีผู้ใช้ของ Line
 */
function deleteUser(lineUserId) {
  const deleteUser = db.prepare("delete from users where lineUserId = ?");
  const deleteTransaction = db.prepare(
    "delete from transactions where lineUserId = ?",
  );

  db.transaction(() => {
    deleteUser.run(lineUserId);
    deleteTransaction.run(lineUserId);
  })();
}

/**
 * บันทึกธุรกรรมลงในฐานข้อมูล
 * @param {string} lineUserId - ไอดีของผู้ใช้ในไลน์
 * @param {string} name - ชื่อของธุรกรรม
 * @param {number} amount - จำนวนเงินของธุรกรรม
 * @throws {Error} เมื่อเกิดข้อผิดพลาดในการบันทึกธุรกรรม
 */
function saveTransaction(lineUserId, name, amount) {
  const insertTransaction = db.prepare(
    "insert into transactions (lineUserId, name, amount) values (?, ?, ?)",
  );
  insertTransaction.run(lineUserId, name, amount);
}

const intervalTypes = ["days", "months", "years"];
/**
 * ดึงรายงานของธุรกรรมภายในช่วงเวลาที่กำหนด
 * @param {string} lineUserId - ไอดีของผู้ใช้ในไลน์
 * @param {number} lookback - จำนวนที่ต้องการดูย้อนหลังสำหรับรายงาน
 * @param {string} interval - ช่วงเวลาที่ต้องการดูย้อนหลังสำหรับรายงาน ("days", "months", "years") (ค่าเริ่มต้นคือ 'days')
 * @returns {Object} ออบเจ็กต์ที่ประกอบด้วยจำนวนธุรกรรมและยอดเงินรวมในช่วงเวลาที่กำหนด
 * @throws {Error} เมื่อเกิดข้อผิดพลาดในการดึงรายงาน
 */
function getReport(lineUserId, lookback, interval) {
  if (intervalTypes.includes(interval) === false) {
    throw new Error(
      'ช่วงเวลาไม่ถูกต้อง ระบุเป็น "days", "months", หรือ "years" ได้เท่านั้น',
    );
  }

  const lookbackPreparedStr = `-${lookback} ${interval}`;

  const getTransactionCount = db.prepare(
    `select count(*) as transactionCount from transactions where lineUserId = ? and datetime(date) >= datetime('now', ?)`,
  );
  const getTotalAmount = db.prepare(
    `select sum(amount) as totalAmount from transactions where lineUserId = ? and datetime(date) >= datetime('now', ?)`,
  );

  const transactions = getTransactionCount.get(
    lineUserId,
    lookbackPreparedStr,
  ).transactionCount;
  const totalAmount = getTotalAmount.get(
    lineUserId,
    lookbackPreparedStr,
  ).totalAmount;

  return { transactions, totalAmount };
}

module.exports = { createUser, deleteUser, saveTransaction, getReport };
