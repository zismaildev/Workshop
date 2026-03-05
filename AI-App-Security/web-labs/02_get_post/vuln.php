<?php
$price = $_GET['price'] ?? '100';
$qty = $_POST['qty'] ?? '1';
$total = (int)$price * (int)$qty;
?>
<!doctype html><html lang="th"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>GET/POST Trust (Vulnerable)</title><link rel="stylesheet" href="../assets/style.css"></head><body>
<div class="container">
  <div class="card"><div class="row">
    <a class="btn secondary" href="./index.php">← Lab</a><span class="badge">VULNERABLE</span>
  </div><h1>Lab 02 — Trust GET/POST</h1><small>เชื่อค่า price จาก URL</small></div>

  <div class="card">
    <h2>GET: เลือกราคา (แก้ URL ได้)</h2>
    <div class="row">
      <a class="btn" href="?price=100">price=100</a>
      <a class="btn" href="?price=200">price=200</a>
      <a class="btn" href="?price=1">price=1</a>
      <a class="btn" href="?price=0">price=0</a>
    </div>
    <hr><p>Price จาก GET = <b><?php echo $price; ?></b></p>
  </div>

  <div class="card">
    <h2>POST: ใส่จำนวน</h2>
    <form method="POST" action="?price=<?php echo urlencode($price); ?>">
      <input type="number" name="qty" min="1" value="<?php echo htmlspecialchars($qty, ENT_QUOTES, 'UTF-8'); ?>">
      <button type="submit">Submit (POST)</button>
    </form>
    <hr><p>รวม (เชื่อ price): <b><?php echo $total; ?></b> บาท</p>
  </div>
</div></body></html>
