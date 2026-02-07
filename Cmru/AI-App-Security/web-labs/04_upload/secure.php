<?php
$msg = ""; $link = "";
if (isset($_FILES['f'])) {
  $tmp = $_FILES['f']['tmp_name'];
  $finfo = finfo_open(FILEINFO_MIME_TYPE);
  $type = finfo_file($finfo, $tmp);
  if (!in_array($type, ['image/jpeg','image/png'], true)) {
    $msg = "Invalid file type (อนุญาตเฉพาะ JPG/PNG)";
  } else {
    $ext = ($type === 'image/png') ? '.png' : '.jpg';
    $name = uniqid("img_", true) . $ext;
    $target = "uploads/" . $name;
    if (move_uploaded_file($tmp, $target)) { $msg="Upload success (ตรวจ MIME + เปลี่ยนชื่อไฟล์)"; $link=$target; }
    else { $msg="Upload failed"; }
  }
}
?>
<!doctype html><html lang="th"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Upload (Secure)</title><link rel="stylesheet" href="../assets/style.css"></head><body>
<div class="container">
  <div class="card"><div class="row">
  </div><h1>Lab 04 — File Upload (Fixed)</h1><small>ตรวจ MIME จริง + เปลี่ยนชื่อไฟล์</small></div>

  <div class="card">
    <h2>อัปโหลดรูป</h2>
    <form method="post" enctype="multipart/form-data">
      <input type="file" name="f" accept=".jpg,.jpeg,.png" required>
      <button type="submit">Upload</button>
    </form>
    <?php if ($msg): ?>
      <hr><div class="note"><b><?php echo htmlspecialchars($msg, ENT_QUOTES, 'UTF-8'); ?></b></div>
      <?php if ($link): ?><p>ไฟล์: <a href="<?php echo htmlspecialchars($link, ENT_QUOTES, 'UTF-8'); ?>"><?php echo htmlspecialchars($link, ENT_QUOTES, 'UTF-8'); ?></a></p><?php endif; ?>
    <?php endif; ?>
  </div>
</div></body></html>
