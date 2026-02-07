<?php
// index_secure.php — เวอร์ชันแก้ไขแล้ว (Scan ซ้ำควรมี alert ลดลง)
//
// การแก้ไขที่ทำ:
// 1) XSS: escape output ด้วย htmlspecialchars
// 2) Security Headers: เพิ่ม header พื้นฐาน
// 3) Info Disclosure: ปิด display_errors และไม่เปิด phpinfo/stack ต่อผู้ใช้

header("X-Frame-Options: DENY");
header("X-Content-Type-Options: nosniff");
// CSP แบบง่ายสำหรับเดโม (จริง ๆ ควรปรับตาม assets ที่ใช้งาน)
header("Content-Security-Policy: default-src 'self'; style-src 'self'; script-src 'self'; object-src 'none'; base-uri 'self'; frame-ancestors 'none'");

ini_set('display_errors', '0');
error_reporting(0);

$q = $_GET['q'] ?? '';
$action = $_GET['action'] ?? '';
$safe_q = htmlspecialchars($q, ENT_QUOTES, 'UTF-8');
?>
<!doctype html>
<html lang="th">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>OWASP ZAP Lab — Secure</title>
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
  <div class="container">
    <div class="card">
      <div class="row">
        <h1>OWASP ZAP Lab <span class="badge">SECURE</span></h1>
      </div>
      <small>
        โหมดปัจจุบัน: <b>secure</b> |
        กลับไปโหมดช่องโหว่: <a href="?mode=vuln">vuln</a>
      </small>
      <div class="hr"></div>
      <div class="note">
        <b>แนวคิด:</b> Escape output + ใส่ Security Headers + ไม่เปิดเผย error ภายในระบบ
      </div>
    </div>

    <div class="card">
      <h2>1) Reflected XSS (แก้แล้ว)</h2>
      <p>เราจะแสดงผลด้วยการ escape เพื่อไม่ให้ script รัน</p>
      <form method="GET" action="">
        <input type="hidden" name="mode" value="secure" />
        <input type="text" name="q" placeholder="Type something..." value="<?php echo $safe_q; ?>" />
        <button type="submit">Search</button>
      </form>

      <?php if ($q !== ''): ?>
        <p>Result: <?php echo $safe_q; ?></p>
      <?php endif; ?>
    </div>

    <div class="card">
      <h2>2) Information Disclosure (แก้แล้ว)</h2>
      <p>โหมดนี้ไม่อนุญาตให้ trigger error หรือเปิด phpinfo ต่อผู้ใช้</p>
      <div class="row">
        <a href="?mode=secure&action=trigger_error">Trigger Error</a>
        <a href="?mode=secure&action=phpinfo">phpinfo()</a>
      </div>

      <?php
      if ($action !== '') {
          // แสดงข้อความทั่วไปแทนรายละเอียดภายใน
          echo "<p>System error, please contact administrator.</p>";
          // ในระบบจริงควร log ไปไฟล์/ระบบ log แทน (ไม่โชว์ให้ user)
      }
      ?>
      <pre>Security Headers enabled:
- X-Frame-Options: DENY
- X-Content-Type-Options: nosniff
- Content-Security-Policy: default-src 'self' ...
</pre>
    </div>

    <div class="card">
      <h2>3) Missing Security Headers (แก้แล้ว)</h2>
      <p>เพิ่ม header ขั้นพื้นฐานแล้ว (ZAP ควรแจ้งเตือนน้อยลง)</p>
    </div>
  </div>
</body>
</html>
