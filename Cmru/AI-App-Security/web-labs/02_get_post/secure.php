<?php
$allowed_prices = [100,200,300];
$price = $_GET['price'] ?? '100';
$msg = "";
if (!in_array((int)$price, $allowed_prices, true)) {
  http_response_code(400);
  $msg = "Invalid price (whitelist)";
  $price = '100';
}
$qty = max(1, (int)($_POST['qty'] ?? '1'));
$total = (int)$price * $qty;
?>
<!doctype html><html lang="th"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>GET/POST Trust (Secure)</title><link rel="stylesheet" href="../assets/style.css"></head><body>
<div class="container">
  <div class="card"><div class="row">
  </div><h1>Lab 02 — Trust GET/POST (Fixed)</h1><small>whitelist + validate</small></div>

  <div class="card">
    <h2>GET: เลือกราคา</h2>
    <div class="row">
      <a class="btn" href="?price=100">price=100</a>
      <a class="btn" href="?price=200">price=200</a>
      <a class="btn" href="?price=1">ลอง price=1</a>
      <a class="btn" href="?price=0">ลอง price=0</a>
    </div>
    <?php if ($msg): ?><hr><div class="note"><b><?php echo $msg; ?></b></div><?php endif; ?>
    <hr><p>Price ที่ยอมรับ = <b><?php echo (int)$price; ?></b></p>
  </div>

  <div class="card">
    <h2>POST: ใส่จำนวน</h2>
    <form method="POST" action="?price=<?php echo urlencode($price); ?>">
      <input type="number" name="qty" min="1" value="<?php echo $qty; ?>">
      <button type="submit">Submit (POST)</button>
    </form>
    <hr><p>รวม: <b><?php echo $total; ?></b> บาท</p>
  </div>
</div></body></html>
