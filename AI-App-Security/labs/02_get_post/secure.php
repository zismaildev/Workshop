<?php
$allowed = [100,200,300];
$price = $_GET['price'] ?? '';
if (!in_array($price, $allowed)) die("Invalid price");
echo "Price = $price บาท";
?>