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
if (!isset($vars['userEmail']) || !isset($vars['code'])) {
    echo json_encode(array("error" => "Missing required parameters"));
    exit;
}

$userEmail = $vars['userEmail'];
$code = $vars['code'];


$query = "SELECT * FROM USERS WHERE email = ? AND email_verif_code = ?";
$result = $db->query($query, $userEmail, $code)->fetchArray();

if (!empty($result)) {
    // Valid email verification code
    // Update the is_verified column to mark the user as verified
    $updateQuery = "UPDATE USERS SET is_verified = 1 WHERE email = ?";
    $db->query($updateQuery, $userEmail);

    echo json_encode(array("success" => "Email verified successfully"));
} else {
    // Invalid email verification code
    echo json_encode(array("error" => "Invalid email verification code"));
}

// Close the database connection
$db->close();
?>
