<?php $q = $_GET['q'] ?? ''; ?>
<!doctype html><html lang="th"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>XSS (Vulnerable)</title><link rel="stylesheet" href="../assets/style.css"></head><body>
<div class="container">
  <div class="card"><div class="row">
    <a class="btn secondary" href="./index.php">← Lab</a><span class="badge">VULNERABLE</span>
  </div><h1>Lab 01 — XSS (Reflected)</h1><small>echo input ตรง ๆ</small></div>
  <div class="card">
    <h2>ทดลอง</h2>
    <form method="GET">
      <input type="text" name="q" value="<?php echo $q; ?>" placeholder="ลองพิมพ์ หรือใส่ payload">
      <button type="submit">Submit (GET)</button>
    </form>
    <hr>
    <div class="row">
      <a class="btn" href="?q=hello">q=hello</a>
      <a class="btn" href="?q=%3Cscript%3Ealert('XSS')%3C%2Fscript%3E">payload</a>
    </div>
    <?php if ($q !== ''): ?>
      <hr><p>Result (ไม่ปลอดภัย): <?php echo $q; ?></p>
    <?php endif; ?>
  </div>
</div></body></html>
