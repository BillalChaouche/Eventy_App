<?php
include("email_functions.php");
include("./database/db_users.php"); // Include the DBUsers class

// Get the raw JSON data from the request
$jsonData = file_get_contents("php://input");

// Decode the JSON data
$vars = json_decode($jsonData, true);
// Check if JSON decoding was successful
if ($vars === null) {
    echo json_encode(array("error" => "Invalid JSON data"));
    exit;
}

if (!isset($vars['action'])) {
    echo json_encode(array("error" => "Action not specified"));
    exit;
}

// Create an instance of the DBUsers class
$dbUsers = new DBUsers();

switch ($vars['action']) {
    case "signup": {
            $name = $vars['name'];
            $email = $vars['email'];
            $password = $vars['password'];

            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

            // Generate a verification code (you should implement this function)
            $verificationCode = generateVerificationCode();

            // Call the insertUser method to add a new user
            if ($dbUsers->insertUser($name, null, null, null, null, null, $email, $hashedPassword, $verificationCode, 0)) {
                print("user is inserted in remote database") ; 
                // Send the verification code to the user's email
                echo json_encode(array("success" => "Sign Up successful from server"));
                sendVerificationCode($email, $verificationCode);

                
            } else {
                echo json_encode(array("error" => "not successeful"));
            }
        }
        break;

    case "login": {
            $email = $vars['email'];
            $password = $vars['password'];

            // Fetch user record from the database based on the email
            $user = $dbUsers->getUserByEmail($email);

            if ($user !== null) {
                // User found, verify the password
                $hashedPassword = $user['password_hash'];

                if (password_verify($password, $hashedPassword)) {
                    // Password is correct, user is authenticated
                    if ($user['verified']===1)
                    {
                        echo json_encode(array("success" => "Login successful from server"));
                    }
                    else{
                        echo json_encode(array("error" => "user not verified yet"));
                    }
                
                } else {
                    // Password is incorrect
                    echo json_encode(array("error" => "Invalid password"));
                }
            } else {
                // User not found
                echo json_encode(array("error" => "User not found"));
            }
        }
        break;
        case "get_user_by_email": {
            $email = $vars['email'];

            // Fetch user record from the database based on the email
            $user = $dbUsers->getUserByEmail($email);

            if ($user !== null) {
              echo json_encode(array("user" => $user));

            } else {
                // User not found
                echo json_encode(array("error" => "User not found"));
            }
        }
        break;
}
?>
