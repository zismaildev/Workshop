<?php
session_start();
if (isset($_GET['as'])) {
  if ($_GET['as'] === 'admin') $_SESSION['role'] = 'admin';
  if ($_GET['as'] === 'user')  $_SESSION['role'] = 'user';
  header("Location: secure.php"); exit;
}
if (isset($_GET['logout'])) { session_destroy(); header("Location: secure.php"); exit; }
$role = $_SESSION['role'] ?? 'guest';
if ($role !== 'admin') { http_response_code(403); }
?>
<!doctype html><html lang="th"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Access Control (Secure)</title><link rel="stylesheet" href="../assets/style.css"></head><body>
<div class="container">
  <div class="card"><div class="row">
  </div><h1>Lab 03 — Access Control (Fixed)</h1><small>ตรวจ role จาก session</small></div>

  <div class="card">
    <h2>Mock Login</h2>
    <p>Role: <b><?php echo htmlspecialchars($role, ENT_QUOTES, 'UTF-8'); ?></b></p>
    <div class="row">
      <a class="btn" href="?as=user">Login as user</a>
      <a class="btn" href="?as=admin">Login as admin</a>
      <a class="btn secondary" href="?logout=1">Logout</a>
    </div>
  </div>

  <div class="card">
    <h2>Admin Panel</h2>
    <?php if ($role !== 'admin'): ?>
      <div class="note"><b>403 Access denied</b> — ต้องเป็น admin เท่านั้น</div>
    <?php else: ?>
      <p><b>Welcome admin!</b> เข้าถึง Admin Panel ได้</p>
    <?php endif; ?>
  </div>
</div></body></html>
