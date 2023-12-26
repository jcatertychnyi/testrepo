<?php
$ini = parse_ini_file(".env");
// print_r($ini);

$servername = $ini['DB_HOST'];
$username = $ini['DB_USER'];
$password = $ini['DB_PASSWORD'];
$base= $ini['DB_NAME'];
$port= $ini['DB_PORT'];

// Create connection
$conn = new mysqli($servername, $username, $password, $base, $port);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
echo "<br/>";
echo "<br/> MYSQL connected successfully<br/>";
echo "<br/>";



?>