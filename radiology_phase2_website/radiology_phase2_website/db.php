<?php
session_start();
$host = "localhost";
$user = "root";
$password = ""; // put your MySQL password here if you have one
$database = "Radiology_Department";
$conn = new mysqli($host, $user, $password, $database);
if ($conn->connect_error) { die("Database connection failed: " . $conn->connect_error); }
$conn->set_charset("utf8mb4");
function esc($v){ return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8'); }
function require_login(){ if(!isset($_SESSION['user_id'])){ header('Location: login.php'); exit; } }
function require_role($roles){ require_login(); if(!in_array($_SESSION['role'], (array)$roles)){ header('Location: index.php'); exit; } }
function current_entity_id($conn, $role){
    $uid = intval($_SESSION['user_id']);
    if($role=='Patient'){ $r=$conn->query("SELECT Patient_ID id FROM PATIENT WHERE User_ID=$uid"); }
    elseif($role=='Doctor'){ $r=$conn->query("SELECT Doctor_ID id FROM DOCTOR WHERE User_ID=$uid"); }
    elseif($role=='Nurse'){ $r=$conn->query("SELECT Nurse_ID id FROM NURSE WHERE User_ID=$uid"); }
    else { return null; }
    $row=$r?$r->fetch_assoc():null; return $row?$row['id']:null;
}
?>