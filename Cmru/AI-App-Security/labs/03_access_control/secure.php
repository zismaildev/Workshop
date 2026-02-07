<?php
session_start();
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    http_response_code(403);
    die("Access denied");
}
echo "<h1>Admin Panel</h1>";
?>