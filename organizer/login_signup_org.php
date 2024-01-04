<?php
include(__DIR__."/../email_functions.php");
include(__DIR__."/../database/db_organizers.php"); // Include the DBOrganizers class

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

// Create an instance of the DBOrganizers class
$dbOrganizers = new DBOrganizers();

switch ($vars['action']) {
    case "signup": {
            $name = $vars['name'];
            $email = $vars['email'];
            $password = $vars['password'];

            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

            // Generate a verification code (you should implement this function)
            $verificationCode = generateVerificationCode();

            // Call the insertOrganizer method to add a new organizer
            if ($dbOrganizers->insertOrganizer($name, null, null, null, null, null, $email, $hashedPassword, $verificationCode, 0)) {
                
                // Send the verification code to the organizer's email
                sendVerificationCode($email, $verificationCode);

                echo json_encode(array("message" => "Organizer registered successfully"));
            } else {
                echo json_encode(array("error" => "Error during registration"));
            }
        }
        break;

    case "login": {
            $email = $vars['email'];
            $password = $vars['password'];

            // Fetch organizer record from the database based on the email
            $organizer = $dbOrganizers->getOrganizerByEmail($email);

            if ($organizer !== null) {
                // Organizer found, verify the password
                $hashedPassword = $organizer['password_hash'];

                if (password_verify($password, $hashedPassword)) {
                    // Password is correct, organizer is authenticated
                    echo json_encode(array("success" => "Login successful from server"));
                } else {
                    // Password is incorrect
                    echo json_encode(array("error" => "Invalid password"));
                }
            } else {
                // Organizer not found
                echo json_encode(array("error" => "Organizer not found"));
            }
        }
        break;
        case "get_organizer_by_email": {
            $email = $vars['email'];

            // Fetch user record from the database based on the email
            $user = $dbOrganizers->getOrganizerByEmail($email);

            if ($user !== null) {
              echo json_encode(array("user" => $user));

            } else {
                // User not found
                echo json_encode(array("error" => "User not found"));
            }
        }
        break;
        case "profile":
            $imgpath = $vars['img'];
            $profile = $vars['profile'];
            $organizer = $dbOrganizers->getOrganizerByEmail($profile['email']);
            if ($organizer !== null) {     
            
                $data = array(
                    'name' => $profile['name'],
                    'photoPath' => $imgpath,
                    'role_id' => $organizer['role_id'],
                    'role' => $profile['role'],
                    'birthdate' => $profile['birth_date'], 
                    'location' => $profile['location'],
                    'phone_number' => $profile['phone_number'],
                    'email' => $profile['email'],
                    'password_hash' => $organizer['password_hash'],
                    'verification_num' => $organizer['verification_num'],
                    'verified' => $organizer['verified']
                );
                $res = $dbOrganizers->updateOrganizer(
                    $organizer['id'],
                    $data
                    
                );
                if ($res) {
                    echo json_encode(array("success" => "Updated successfully"));
                } else {
                    echo json_encode(array("error" => "Something went wrong"));
                }
            } else {
                echo json_encode(array("error" => "User not found"));
            }
            break;
            case "getUserInfo":{
                $email = $vars['email'];
                $organizer = $dbOrganizers->getOrganizerByEmail($email);
                if ($organizer) {
                    echo json_encode($organizer);
                    exit;
                } else {
                    echo json_encode(array("error" => "User not found"));
                    exit;
                }
            }
    
}
?>
