<?php
include("init.php");
include("email_functions.php");

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
if (!isset($vars['email'])) {
    echo json_encode(array("error" => "Missing required parameters"));
    exit;
}

$email = $vars['email'];


// Build the SQL query using a prepared statement
$query = "SELECT * FROM users WHERE email = ? ";
$result = $db->query($query , $email)->fetchArray();

if (!empty($result)) {
    // Generate a verification code (you should implement this function)
    $verificationCode = generateVerificationCode();
    //send the verification code to that email 
    sendVerificationCode($email, $verificationCode);
    // Update the code column 
    $updateQuery = "UPDATE users SET verification_num = $verificationCode WHERE email = ?";
    $db->query($updateQuery, $email);

    echo json_encode(array("success" => "code is sent and updated successfully "));
} else {
    // Invalid email verification code
    echo json_encode(array("error" => "Invalid email"));
}

// Close the database connection
$db->close();
?>
