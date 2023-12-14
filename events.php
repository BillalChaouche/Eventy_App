<?php
include("init.php");
include("email_functions.php");

// Get the raw JSON data from the request
$jsonData = file_get_contents("php://input");

// Decode the JSON data
//$vars = json_decode($jsonData, true);

// Check if JSON decoding was successful
if ($vars === null) {
    echo json_encode(array("error" => "Invalid JSON data"));
    exit;
}

if (!isset($vars['action'])) {
    echo json_encode(array("error" => "Action not specified"));
    exit;
}

switch ($vars['action']) {
    case "events.get": {
        $id = $vars['id'];
        $items = $db->query("SELECT events.*, users_events.*,categories.name AS category
        FROM events
        INNER JOIN users_events ON events.id = users_events.event_id
        INNER JOIN categories ON events.category_id = categories.id
        WHERE users_events.user_id = ?", $id)->fetchAll();
        echo json_encode ($items);
        exit;
    }
    case "events.update": {
        $user_id = $vars['user_id'];
        $event_id = $vars['event_id'];
        $saved = $vars['saved'];
        $booked = $vars['booked'];
    
        // Assuming $saved and $booked are integer values (1 or 0)
        $result = $db->query("UPDATE users_events 
                    SET saved = ?, booked = ? 
                    WHERE user_id = ? AND event_id = ?", 
                    [$saved, $booked, $user_id, $event_id]);
        if($result){
            return true;
        }
        return false;
        
    }
    
}
?>
