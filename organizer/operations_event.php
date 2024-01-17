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
    case 'test':
        $codes = generateUniqueCodes(1, 8);
        // save them on database
        insertCodesIntoDatabase($db,1,6,$codes);
        break;
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

                    if($event['remote_id'] == null){

                     $response = insertEvent($event);
                     if (isset($response['success'])) {

                        
                    $eventID = $response['event_id'];
                    $codes = generateUniqueCodes($event['attendees'], 8);
                     // save them on database
                     insertCodesIntoDatabase($db,$eventID,$organizerId,$codes);
                     }
                     // Respond to the client with the array of responses
                     respondToClient($responses);
                    }
                    else $response = updateEvent($event['remote_id'], $event);

                    
    
                    // Validate and insert event
                    
    
                    // Accumulate responses in an array
                    $responses[] = $response;
                }
                // generate codes for booking user
                
    
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
    
    case 'getUserBooked':
        if(isset($data['eventID'])){
            $eventID = $data['eventID'];
            $usersBooked = $db->query("
            SELECT ue.*, u.name, u.photo_path
            FROM users_events ue
            JOIN users u ON ue.user_id = u.id
            WHERE ue.event_id = ?
        ", $eventID)->fetchAll();

        echo json_encode($usersBooked);
            exit;

        }
        else{
            respondError('eventID is required for deletion');
        }
        break;

    case 'acceptUser':
        $eventID = $data['eventID'];
        $userID = $data['userID'];

        // Retrieve the booking code for the specified eventID
        $codeQuery = "SELECT code FROM bookingCodes WHERE event_id = ? LIMIT 1";
        $codeResult = $db->query($codeQuery, $eventID)->fetchAll();

        if ($codeResult && count($codeResult) > 0) {
            $code = $codeResult[0]['code'];

            // Delete the booking code from the bookingCodes table
            $deleteQuery = "DELETE FROM bookingCodes WHERE code = ? AND event_id = ?";
            $deleteResult = $db->query($deleteQuery, [$code, $eventID]);

            if ($deleteResult) {
            // Insert into the users_events table
            $updateQuery = "UPDATE users_events SET code = ?, accepted = 1 WHERE event_id = ? AND user_id = ?";
            $updateResult = $db->query($updateQuery, [$code, $eventID, $userID]);

              if ($updateResult) {
                // Successfully accepted user for the event
                // Handle any success response or return appropriate data
                echo json_encode(array("success" => "user accpeted successfully"));
              } else {
            // Handle insertion error into users_events table
            echo json_encode(array("error" => "error occur on the server"));
        }
        } else {
        // Handle deletion error from bookingCodes table
        echo json_encode(array("error" => "error occur on the server"));
    }
    } else {
    // Handle no available code for the eventID
    echo json_encode(array("error" => "reach limit of booking"));
    }
    break;

    case 'userScan':
        $eventID = $data['eventID'];
        $code = $data['code'];
    
        // Check if the row exists in the users_events table
        $scanQuery = "SELECT user_id FROM users_events WHERE event_id = ? AND code = ? LIMIT 1";
        $scanResult = $db->query($scanQuery, [$eventID, $code])->fetchAll();
    
        if ($scanResult && count($scanResult) > 0) {
            $userID = $scanResult[0]['user_id'];
    
            // Update the scanned attribute to 1
            $updateQuery = "UPDATE users_events SET scanned = 1 WHERE event_id = ? AND code = ?";
            $updateResult = $db->query($updateQuery, [$eventID, $code]);
    
            if ($updateResult) {
                // Successfully updated the scanned attribute
                echo json_encode(array("user_id" => $userID));
            } else {
                // Handle update error in users_events table
                echo json_encode(array("error" => "Error updating scanned attribute"));
            }
        } else {
            // Row with the specified eventID and code not found
            echo json_encode(array("error" => "Invalid eventID or code"));
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
function generateRandomCode($length) {
    $chars = "0123456789"; // Characters to use for generating the code
    $code = "";
    $charsLength = strlen($chars);
    
    for ($i = 0; $i < $length; $i++) {
        $code .= $chars[rand(0, $charsLength - 1)];
    }
    
    return $code;
}

function generateUniqueCodes($n, $length) {
    $uniqueCodes = [];
    
    // Loop to generate n unique codes
    while (count($uniqueCodes) < $n) {
        $code = generateRandomCode($length);
        if (!in_array($code, $uniqueCodes)) {
            $uniqueCodes[] = $code;
        }
    }
    
    return $uniqueCodes;
}
function insertCodesIntoDatabase($db, $eventID, $organizerID, $codes) {
    foreach ($codes as $code) {
        $db->query("INSERT INTO bookingcodes (event_id, organizer_id, code) VALUES (?, ?, ?)", $eventID, $organizerID, $code);
    }
}

?>