<?php
ini_set('display_errors', '0');
error_reporting(0);
$action = $_GET['action'] ?? '';
?>
<!doctype html><html lang="th"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>phpinfo & Error (Secure)</title><link rel="stylesheet" href="../assets/style.css"></head><body>
<div class="container">
  <div class="card"><div class="row">
  </div><h1>Lab 05 — phpinfo & Error Disclosure (Fixed)</h1><small>ปิด display_errors และไม่โชว์รายละเอียดให้ผู้ใช้</small></div>

  <div class="card">
    <h2>เลือก action</h2>
    <div class="row">
      <a class="btn" href="?action=phpinfo">phpinfo()</a>
      <a class="btn" href="?action=trigger_error">Trigger Error</a>
    </div>
    <hr>
    <?php
      if ($action !== '') {
        echo "<div class='note'><b>System error</b> — please contact administrator.</div>";
      } else {
        echo "<p>ยังไม่ได้เลือก action</p>";
      }
    ?>
  </div>
</div></body></html>
