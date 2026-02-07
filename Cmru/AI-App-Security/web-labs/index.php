<?php ?>
<!doctype html>
<html lang="th">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>PHP Security Web Labs</title>
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
  <div class="container">
    <div class="card">
      <h1>PHP Security Web Labs <span class="badge">XAMPP</span></h1>
      <small>สำหรับเรียน/ทดสอบใน <b>localhost</b> เท่านั้น • แนะนำเปิดผ่าน OWASP ZAP Browser แล้ว Spider/Active Scan</small>
      <hr>
      <div class="note">
        <b>ให้ ZAP จับได้ง่าย:</b> เปิดหน้านี้ → คลิกเข้าแต่ละ Lab → ในแต่ละหน้าให้กดปุ่ม/ส่งฟอร์ม 1 ครั้ง แล้วค่อย Spider/Active Scan
      </div>
    </div>

    <div class="card">
      <h2>เลือก Lab</h2>
      <div class="row">
        <a class="btn" href="01_xss/">01 XSS</a>
        <a class="btn" href="02_get_post/">02 GET/POST Trust</a>
        <a class="btn" href="03_access_control/">03 Access Control</a>
        <a class="btn" href="04_upload/">04 File Upload</a>
        <a class="btn" href="05_phpinfo_error/">05 phpinfo & Error</a>
      </div>
    </div>

    <div class="card">
      <h2>ลิงก์รวม (ให้ Spider เก็บง่าย)</h2>
      <ul>
        <li><a href="01_xss/vuln.php">01_xss/vuln.php</a> | <a href="01_xss/secure.php">secure.php</a></li>
        <li><a href="02_get_post/vuln.php?price=100">02_get_post/vuln.php</a> | <a href="02_get_post/secure.php?price=100">secure.php</a></li>
        <li><a href="03_access_control/vuln.php">03_access_control/vuln.php</a> | <a href="03_access_control/secure.php">secure.php</a></li>
        <li><a href="04_upload/vuln.php">04_upload/vuln.php</a> | <a href="04_upload/secure.php">secure.php</a></li>
        <li><a href="05_phpinfo_error/vuln.php">05_phpinfo_error/vuln.php</a> | <a href="05_phpinfo_error/secure.php">secure.php</a></li>
      </ul>
    </div>
  </div>
</body>
</html>
