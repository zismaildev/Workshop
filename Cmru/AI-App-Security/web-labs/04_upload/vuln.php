<?php
$msg = ""; $link = "";
if (isset($_FILES['f'])) {
  $name = $_FILES['f']['name'];
  $target = "uploads/" . $name;
  if (move_uploaded_file($_FILES['f']['tmp_name'], $target)) { $msg="Upload success (ไม่ตรวจชนิดไฟล์)"; $link=$target; }
  else { $msg="Upload failed"; }
}
?>
<!doctype html><html lang="th"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Upload (Vulnerable)</title><link rel="stylesheet" href="../assets/style.css"></head><body>
<div class="container">
  <div class="card"><div class="row">
    <a class="btn secondary" href="./index.php">← Lab</a><span class="badge">VULNERABLE</span>
  </div><h1>Lab 04 — File Upload (Vulnerable)</h1><small>ไม่ตรวจ MIME/นามสกุล และใช้ชื่อไฟล์จากผู้ใช้</small></div>

  <div class="card">
    <h2>อัปโหลดไฟล์</h2>
    <form method="post" enctype="multipart/form-data">
      <input type="file" name="f" required>
      <button type="submit">Upload</button>
    </form>
    <?php if ($msg): ?>
      <hr><div class="note"><b><?php echo htmlspecialchars($msg, ENT_QUOTES, 'UTF-8'); ?></b></div>
      <?php if ($link): ?><p>ไฟล์: <a href="<?php echo htmlspecialchars($link, ENT_QUOTES, 'UTF-8'); ?>"><?php echo htmlspecialchars($link, ENT_QUOTES, 'UTF-8'); ?></a></p><?php endif; ?>
    <?php endif; ?>
    <hr><ul><li><a href="uploads/">เปิดโฟลเดอร์ uploads/</a></li></ul>
  </div>
</div></body></html>
