<?php
$q = $_GET['q'] ?? '';
$safe = htmlspecialchars($q, ENT_QUOTES, 'UTF-8');
header("X-Content-Type-Options: nosniff");
header("X-Frame-Options: DENY");
header("Content-Security-Policy: default-src 'self'; script-src 'self'");
?>
<!doctype html><html lang="th"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>XSS (Secure)</title><link rel="stylesheet" href="../assets/style.css"></head><body>
<div class="container">
  <div class="card"><div class="row">
  </div><h1>Lab 01 — XSS (Fixed)</h1><small>escape output + headers</small></div>
  <div class="card">
    <h2>ทดลอง</h2>
    <form method="GET">
      <input type="text" name="q" value="<?php echo $safe; ?>" placeholder="payload เดิมจะไม่รัน">
      <button type="submit">Submit (GET)</button>
    </form>
    <hr>
    <div class="row">
      <a class="btn" href="?q=hello">q=hello</a>
      <a class="btn" href="?q=%3Cscript%3Ealert('XSS')%3C%2Fscript%3E">payload</a>
    </div>
    <?php if ($q !== ''): ?>
      <hr><p>Result (ปลอดภัย): <?php echo $safe; ?></p>
    <?php endif; ?>
  </div>
</div></body></html>
