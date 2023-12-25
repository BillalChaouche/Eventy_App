<?php
include(__DIR__ . "/../database/db_events.php");

error_reporting(E_ALL);
ini_set('display_errors', 1);



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
            INNER JOIN categories ON events.category_id = categories.id WHERE events.organizer_id = ?", $userId)->fetchAll();
            echo json_encode($items);
            exit;
        } else {
            echo json_encode(array("error" => "User not found"));
            exit;
        }
        case 'addEvents':
    
            // Check if 'events' parameter is set and is an array
            if (isset($data['events']) && is_array($data['events'])) {
                $eventsData = $data['events'];
                // Retrieve the organizer ID based on the provided email
                $organizerEmail = $data['email'];
                $organizer = $db->query("SELECT * FROM organizers WHERE email = ?", $organizerEmail)->fetchAll();

                if (!$organizer) {
                    respondError('Organizer not found');
                }
    
                $organizerId = $organizer[0]['id'];
                // Validate each event and insert into the database
                $responses = array();
    
                foreach ($eventsData as $event) {
                    // Add organizer_id to each event
                    $event['organizer_id'] = $organizerId;
    
                    // Add category_id to each event (assuming you have a category field in $event)
                    $categoryName = $event['category']; // Update this based on your event structure
                    $categories = $db->query("SELECT * FROM categories WHERE name = ?", $categoryName)->fetchAll();
    
                    if (!$categories) {
                        respondError('Category not found');
                    }
    
                    $event['category_id'] = $categories[0]['id'];
                    $response;

                    if($event['remote_id'] == null) $response = insertEvent($event);
                    else $response = updateEvent($event['remote_id'], $event);
    
                    // Validate and insert event
                    
    
                    // Accumulate responses in an array
                    $responses[] = $response;
                }
    
                // Respond to the client with the array of responses
                respondToClient($responses);
    
            } else {
                respondError('Invalid or missing events data');
            }
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