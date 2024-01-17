<?php

include("init.php");

// Get the raw JSON data from the request
$jsonData = file_get_contents("php://input");

// Decode the JSON data
$vars = json_decode($jsonData, true);

// Check if JSON decoding was successful
if ($vars === null) {
    echo json_encode(array("error" => "Invalid JSON data"));
    exit;
}

// Check if required parameters are present
if (!isset($vars['email']) || !isset($vars['code']) ) {
    echo json_encode(array("error" => "Missing required parameters"));
    exit;
}

$userEmail = $vars['email'];
$code = $vars['code'];
// Build the SQL query using a prepared statement
$query1 = "SELECT * FROM users WHERE email = '$userEmail' AND verification_num = '$code'";
$result1 = $db->query($query1)->fetchArray();

$query = "SELECT * FROM organizers WHERE email = '$userEmail' AND verification_num = '$code'";
$result = $db->query($query)->fetchArray();

if (!empty($result)|| !empty($result1)) {
    // Valid email verification code
    echo json_encode(array("success" => "Email verified successfully "));
} else {
    // Invalid email verification code
    echo json_encode(array("error" => "Invalid email verification code"));
}

// Close the database connection
$db->close();
?>
