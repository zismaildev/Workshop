<?php
if(isset($_FILES['f'])){
move_uploaded_file($_FILES['f']['tmp_name'], "uploads/".$_FILES['f']['name']);
echo "Uploaded";
}
?>
<form method="post" enctype="multipart/form-data">
<input type="file" name="f">
<button>Upload</button>
</form>