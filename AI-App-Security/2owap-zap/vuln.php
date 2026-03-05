<?php
// index_vuln.php — เวอร์ชันมีช่องโหว่ (สำหรับสแกนให้เจอ)
//
// ช่องโหว่ที่ตั้งใจใส่:
// 1) Reflected XSS: echo input ตรง ๆ
// 2) Missing Security Headers: ไม่ได้ set header ป้องกัน
// 3) Information Disclosure: เปิดแสดง error และทำให้เกิด error จำลอง

ini_set('display_errors', '1');
error_reporting(E_ALL);

$q = $_GET['q'] ?? '';
$action = $_GET['action'] ?? '';
?>
<!doctype html>
<html lang="th">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>OWASP ZAP Lab — Vulnerable</title>
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
  <div class="container">
    <div class="card">
      <div class="row">
        <h1>OWASP ZAP Lab <span class="badge">VULNERABLE</span></h1>
      </div>
      <small>
        โหมดปัจจุบัน: <b>vuln</b> |
        สลับไปโหมดแก้ไขแล้ว: <a href="?mode=secure">secure</a>
      </small>
      <div class="hr"></div>
      <div class="note">
        <b>เพื่อการเรียนเท่านั้น:</b> ทำเฉพาะ localhost ห้ามใช้กับเว็บจริง/คนอื่นโดยไม่ได้รับอนุญาต
      </div>
    </div>

    <div class="card">
      <h2>1) Reflected XSS Demo</h2>
      <p>ลองใส่ payload เช่น <code>&lt;script&gt;alert('XSS')&lt;/script&gt;</code></p>
      <form method="GET" action="">
        <input type="hidden" name="mode" value="vuln" />
        <input type="text" name="q" placeholder="Type something..." value="<?php echo $q; ?>" />
        <button type="submit">Search</button>
      </form>

      <?php if ($q !== ''): ?>
        <p>Result: <?php echo $q; ?></p>
      <?php endif; ?>
    </div>

    <div class="card">
      <h2>2) Information Disclosure Demo</h2>
      <p>กดปุ่มเพื่อสร้าง error ตัวอย่าง (แสดงรายละเอียดบนหน้าเว็บ)</p>
      <div class="row">
        <a href="?mode=vuln&action=trigger_error">Trigger Error</a>
        <a href="?mode=vuln&action=phpinfo">phpinfo()</a>
      </div>

      <?php
      if ($action === 'trigger_error') {
          // แกล้งเรียกฟังก์ชันที่ไม่มีอยู่ เพื่อให้เกิด fatal error (แสดง stack/รายละเอียด)
          undefined_function_call_demo();
      } elseif ($action === 'phpinfo') {
          phpinfo(); // ตัวอย่าง Information Disclosure (ไม่ควรเปิดบนระบบจริง)
      }
      ?>
    </div>

    <div class="card">
      <h2>3) Missing Security Headers</h2>
      <p>โหมดนี้ <b>ไม่ได้</b> set security headers ใด ๆ เพื่อให้ ZAP แจ้งเตือน</p>
      <ul>
        <li>X-Frame-Options</li>
        <li>X-Content-Type-Options</li>
        <li>Content-Security-Policy</li>
      </ul>
    </div>
  </div>
</body>
</html>
