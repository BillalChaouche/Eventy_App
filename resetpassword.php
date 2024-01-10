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
if (!isset($vars['email'])) {
    echo json_encode(array("error" => "Missing required parameters"));
    exit;
}

$email = $vars['email'];

$password = $vars['password'];

$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
$updateQuery = "UPDATE users SET password_hash = $hashedPassword WHERE email = ?";


if ($db->query($updateQuery, $email)) {
    print("user is updated in remote database") ; 
    // Send the verification code to the user's email
    echo json_encode(array("success" => "Sign Up successful from server"));
    sendVerificationCode($email, $verificationCode);

    
} else {
    echo json_encode(array("error" => "not successeful"));
}
