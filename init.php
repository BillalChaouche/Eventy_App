<?php

include("lib/db.php");
include("lib/utils.php");

$dbhost = 'localhost';
$dbuser = 'root';
$dbname = 'eventy';
$dbpass = '';


$db = new db($dbhost, $dbuser, $dbpass, $dbname);

if (!$db) {
    echo json_encode(array("error" => "Database connection failed"));
    exit;
}


function respondError($message)
{
    header('Content-Type: application/json');
    echo json_encode(['error' => $message]);
    exit;
}


function respondToClient($message)
{
    header('Content-Type: application/json');
    echo json_encode(['success' => $message]);
    exit;
}

$vars=get_input_vars();

?>
