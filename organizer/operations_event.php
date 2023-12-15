<?php

include(__DIR__."/../database/db_events.php");

// Read JSON input from the request
$json_input = file_get_contents('php://input');
$data = json_decode($json_input, true);

if ($data === null) {
    // JSON is invalid
    respondError('Invalid JSON input');
}

if (!isset($data['action'])) {
    respondError('Action is required');
}


switch ($data['action']) {
    case 'getEvents':
        $email = $data['email'];
        
        // Fetch user ID based on the provided email
        $user = $db->query("SELECT * FROM organizers WHERE email = ?", $email)->fetchAll();
        
        if ($user) {
            $userId = $user[0]['id']; // Extract the user ID
            $items = $items = $db->query("SELECT events.*, categories.name AS category
            FROM events
            INNER JOIN categories ON events.category_id = categories.id", $userId)->fetchAll();
            echo json_encode($items);
            exit;
        }
        else{
            echo json_encode(array("error" => "User not found"));
            exit;
        }
    case 'insertEvent':
        validateRequiredFields(['title', 'date', 'time', 'organizer_id', 'category_id'], $data);
        $response = insertEvent($data);
        respondToClient($response);
        break;

    case 'deleteEvent':
        if (isset($data['eventID'])) {
            $response = deleteEvent($data['eventID']);
            respondToClient($response);
        } else {
            respondError('eventID is required for deletion');
        }
        break;

    // Add other cases as needed

    default:
        respondError('Invalid action');
}


function validateRequiredFields($requiredFields, $data)
{
    foreach ($requiredFields as $field) {
        if (!isset($data[$field])) {
            respondError("$field is required");
        }
    }
}


?>