<?php
include ("init.php"); 

// Check if token and userEmail are set in the request
if (isset($_POST['token'], $_POST['userEmail'])) {
    // Sanitize and validate input data
    $token = $_POST['token'];
    $userEmail = $_POST['userEmail'];
    $tablename = $_POST['userType'] == 'Organizer'? 'organizers' : 'users' ;

    // Update the users table with the provided token where email matches
    $query = "UPDATE $tablename SET device_token = '$token' WHERE email = '$userEmail'";
    $db->query($query);

    if ($db->affectedRows() > 0) {
        echo json_encode(['success' => true, 'message' => 'Token updated successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'No rows updated']);
    }

    // Close the database connection
    $db->close();
} else {
    // Invalid request, token and userEmail are not set
    echo json_encode(['success' => false, 'message' => 'Invalid request']);
}
?>
