<?php

include(__DIR__."/../init.php");

function insertUserEvent($data)
{
    global $db;

    // Sanitize input (consider using prepared statements)
    $user_id = $data['user_id'];
    $event_id = $data['event_id'];
    $booked = $data['booked'] ?? null;
    $saved = $data['saved'] ?? null;
    $accepted = $data['accepted'] ?? null;
    $code = $data['code'] ?? null;
    $date = $data['date'] ?? null;
    $scanned = $data['scanned'] ?? null;

    // Insert into the users_events table
    $sql = "INSERT INTO users_events (user_id, event_id, booked, saved, accepted, code, date, scanned)
            VALUES ('$user_id', '$event_id', '$booked', '$saved', '$accepted', '$code', '$date', '$scanned')";

    // Execute the query
    $db->query($sql);

    // Check for errors
    if ($db->affectedRows() > 0) {
        // Successful insertion
        return ['success' => 'User event inserted successfully'];
    } else {
        // Error during insertion
        return ['error' => 'Failed to insert user event'];
    }
}

function updateUserEvent($user_id, $event_id, $data)
{
    global $db;

    // Sanitize input (consider using prepared statements)
    $booked = $data['booked'] ?? null;
    $saved = $data['saved'] ?? null;
    $accepted = $data['accepted'] ?? null;
    $code = $data['code'] ?? null;
    $date = $data['date'] ?? null;
    $scanned = $data['scanned'] ?? null;

    // Update the user event in the users_events table
    $sql = "UPDATE users_events 
            SET booked = '$booked', 
                saved = '$saved', 
                accepted = '$accepted', 
                code = '$code', 
                date = '$date', 
                scanned = '$scanned'
            WHERE user_id = '$user_id' AND event_id = '$event_id'";

    // Execute the query
    $db->query($sql);

    // Check for errors
    if ($db->affectedRows() > 0) {
        // Successful update
        return ['success' => 'User event updated successfully'];
    } else {
        // Error during update
        return ['error' => 'Failed to update user event'];
    }
}


function updateUserEventState($user_id, $event_id, $data)
{
    global $db;

    // Sanitize input (consider using prepared statements)
    $updateColumns = [];

    $allowedColumns = ['booked', 'saved', 'accepted', 'code', 'date', 'scanned'];

    foreach ($allowedColumns as $column) {
        if (isset($data[$column])) {
            $updateColumns[] = "$column = '{$data[$column]}'";
        }
    }

    // Construct the SET clause
    $setClause = implode(', ', $updateColumns);

    // Update the user event in the users_events table
    $sql = "UPDATE users_events 
            SET $setClause
            WHERE user_id = '$user_id' AND event_id = '$event_id'";

    // Execute the query
    $db->query($sql);

    // Check for errors
    if ($db->affectedRows() > 0) {
        // Successful update
        return ['success' => 'User event updated successfully'];
    } else {
        // Error during update
        return ['error' => 'Failed to update user event'];
    }
}


function deleteUserEvent($user_id, $event_id)
{
    global $db;

    // Delete the user event
    $sql = "DELETE FROM users_events WHERE user_id = '$user_id' AND event_id = '$event_id'";
    $db->query($sql);

    // Check for errors
    if ($db->affectedRows() > 0) {
        // Successful deletion
        return ['success' => 'User event deleted successfully'];
    } else {
        // Error during deletion
        return ['error' => 'Failed to delete user event'];
    }
}


function selectUserEvents($user_id)
{
    global $db;

    // Select events for a specific user from the events table
    $sql = "SELECT events.*
            FROM events
            INNER JOIN users_events ON events.id = users_events.event_id
            WHERE users_events.user_id = '$user_id'";

    // Execute the query and fetch results
    $results = $db->query($sql)->fetchAll();

    return $results;
}





?>
