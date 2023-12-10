<?php

include("./database/db_events.php");

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