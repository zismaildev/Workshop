<?php
$q = $_GET['q'] ?? '';
echo "<h1>Search Result</h1>";
echo "You searched: " . htmlspecialchars($q, ENT_QUOTES, 'UTF-8');
?>