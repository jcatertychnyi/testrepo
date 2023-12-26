<?php
$ini = parse_ini_file(".env");
//print_r($ini);

$servername = $ini['DB_HOST'];
$username = $ini['DB_USER'];
$password = $ini['DB_PASSWORD'];
$base= $ini['DB_NAME'];
$port= $ini['DB_PORT'];

// Create connection
$conn = new mysqli($servername, $username, $password, $base, $port);

// Check connection
if ($conn->connect_error) {
  die("<br/> MYSQL Connection failed: " . $conn->connect_error);
}
echo "<br/> MySQL status: connected<br/>";

$connect="host=".$ini['BIGDB_HOST']." user=".$ini['BIGDB_USERNAME']." password=".$ini['BIGDB_PASSWORD']." dbname=".$ini['BIGDB_DATABASE'];

$db = pg_connect($connect) or die('<br/> Postgress Connection failed');

echo "<br/>PostgreSQL status: connected<br/>";



?>