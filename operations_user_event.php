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
        $email = $vars['email'];
        
        // Fetch user ID based on the provided email
        $user = $db->query("SELECT id FROM users WHERE email = ?", $email)->fetchAll();
        
        if ($user) {
            $userId = $user[0]['id']; // Extract the user ID
            
            // Now fetch events using the obtained user ID
            $items = $db->query("SELECT events.*, users_events.*, categories.name AS category
                FROM events
                LEFT JOIN users_events ON events.id = users_events.event_id AND users_events.user_id = ?
                INNER JOIN categories ON events.category_id = categories.id", $userId)->fetchAll();
            
            echo json_encode($items);
            exit;
        } else {
            echo json_encode(array("error" => "User not found"));
            exit;
        }
    }
    case "events.update": {
        $user_email = $vars['user_email'];
        // Fetch user ID based on the provided email
        $user = $db->query("SELECT id FROM users WHERE email = ?", $user_email)->fetchAll();
        if ($user) {
            $userId = $user[0]['id']; // Extract the user ID

        $event_id = $vars['event_id'];
        $saved = $vars['saved'];
        $booked = $vars['booked'];
    
        // Assuming $saved and $booked are integer values (1 or 0)
        $result = $db->query("INSERT INTO users_events (user_id, event_id, saved, booked) 
                    VALUES (?, ?, ?, ?) 
                    ON DUPLICATE KEY UPDATE saved = ?, booked = ?, accepted=?", 
                    [$userId, $event_id, $saved, $booked, $saved, $booked, 0]);
    
        if($result){
            return true;
        }
        return false;
    } else {
    echo json_encode(array("error" => "User not found"));
    exit;
}
    
    
}}
?>
