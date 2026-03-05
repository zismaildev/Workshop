<?php
if(isset($_FILES['f'])){
$finfo = finfo_open(FILEINFO_MIME_TYPE);
$type = finfo_file($finfo, $_FILES['f']['tmp_name']);
if(!in_array($type,['image/jpeg','image/png'])) die("Invalid file");
$name = uniqid().".jpg";
move_uploaded_file($_FILES['f']['tmp_name'], "uploads/".$name);
echo "Uploaded securely";
}
?>
<form method="post" enctype="multipart/form-data">
<input type="file" name="f">
<button>Upload</button>
</form>