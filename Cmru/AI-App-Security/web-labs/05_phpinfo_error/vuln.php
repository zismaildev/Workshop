<?php
ini_set('display_errors', '1');
error_reporting(E_ALL);
$action = $_GET['action'] ?? '';
?>
<!doctype html><html lang="th"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>phpinfo & Error (Vulnerable)</title><link rel="stylesheet" href="../assets/style.css"></head><body>
<div class="container">
  <div class="card"><div class="row">
    <a class="btn secondary" href="./index.php">← Lab</a><span class="badge">VULNERABLE</span>
  </div><h1>Lab 05 — phpinfo & Error Disclosure</h1><small>เปิด phpinfo และแสดง error รายละเอียด</small></div>

  <div class="card">
    <h2>เลือก action</h2>
    <div class="row">
      <a class="btn warn" href="?action=phpinfo">phpinfo()</a>
      <a class="btn warn" href="?action=trigger_error">Trigger Error</a>
    </div>
    <hr>
    <?php
      if ($action === 'phpinfo') { phpinfo(); }
      elseif ($action === 'trigger_error') { $x = 1/0; echo $x; }
      else { echo "<p>ยังไม่ได้เลือก action</p>"; }
    ?>
  </div>
</div></body></html>
