<?php

include(__DIR__ . "/../init.php");

function insertEvent($data)
{
    global $db;
    $title = $data['title'];
    $imagePath = $data['imagePath'] ?? null;
    $start_date = $data['start_date'];
    $end_date = $data['end_date'];
    $start_time = $data['start_time'];
    $end_time = $data['end_time'];
    $description = $data['description'] ?? null;
    $attendees = $data['attendees'] ?? null;
    $location = $data['location'] ?? null;
    $organizer_id = $data['organizer_id'];
    $category_id = $data['category_id'];
    $accept_directly = $data['accept_directly'] ?? null;
    $delete_after_deadline = $data['delete_after_deadline'] ?? null;

    // Insert into the events table
    $sql = "INSERT INTO events (title, imagePath, start_date, end_date, accept_directly, delete_after_deadline, start_time, end_time, description, attendees, location, organizer_id, category_id)
            VALUES ('$title', '$imagePath', '$start_date', '$end_date', '$accept_directly', '$delete_after_deadline', '$start_time', '$end_time', '$description', '$attendees', '$location', '$organizer_id', '$category_id')";

    // Execute the query
    $db->query($sql);

    // Check for errors
    if ($db->affectedRows() > 0) {
        // Successful insertion
        return ['success' => 'Event inserted successfully'];
    } else {
        // Error during insertion
        return ['error' => 'Failed to insert event'];
    }
}

function deleteEvent($eventID)
{
    global $db;

    // Delete the event
    $sql = "DELETE FROM events WHERE id = '$eventID'";
    $db->query($sql);

    // Check for errors
    if ($db->affectedRows() > 0) {
        // Successful deletion
        return ['success' => 'Event deleted successfully'];
    } else {
        // Error during deletion
        return ['error' => 'Failed to delete event'];
    }
}

function updateEvent($eventID, $data)
{
    global $db;

    // Sanitize input (consider using prepared statements)
    $title = $data['title'];
    $imagePath = $data['imagePath'] ?? null;
    //$date = $data['date'];
    //$time = $data['time'];
    $description = $data['description'] ?? null;
    $attendees = $data['attendees'] ?? null;
    $location = $data['location'] ?? null;
    $organizer_id = $data['organizer_id'];
    $category_id = $data['category_id'];


    // Update the event in the events table 
    $sql = "UPDATE events 
            SET title = '$title', 
                imagePath = '$imagePath', 
                description = '$description', 
                attendees = '$attendees', 
                location = '$location', 
                organizer_id = '$organizer_id', 
                category_id = '$category_id'
            WHERE id = '$eventID'";

    // Execute the query
    $db->query($sql);

    // Check for errors
    if ($db->affectedRows() > 0) {
        // Successful update
        return ['success' => 'Event updated successfully'];
    } else {
        // Error during update
        return ['error' => 'Failed to update event'];
    }
}



function filteredSearch($data)
{
    global $db;

    // Check if JSON input is valid
    if ($data === null) {
        respondError('Invalid JSON input');
    }

    // Build the SQL query
    $sql = "SELECT events.*, categories.name AS category_name, organizers.name AS organizer_name
            FROM events
            LEFT JOIN categories ON events.category_id = categories.id
            LEFT JOIN organizers ON events.organizer_id = organizers.id
            WHERE 1=1";

    // Loop through each filter in the JSON input
    foreach ($data as $column => $value) {
        // Add the condition to the SQL query
        $sql .= " AND $column = '$value'";
    }

    // Execute the query and fetch results
    $results = $db->query($sql)->fetchAll();

    return $results;

}


function selectOrganizerEvents($organizer_id)
{
    global $db;

    // Sanitize input (consider using prepared statements)
    $organizer_id = intval($organizer_id);

    // Build the SQL query to select events for a specific organizer
    $sql = "SELECT * FROM events WHERE organizer_id = $organizer_id";

    // Execute the query and fetch results
    $results = $db->query($sql)->fetchAll();

    return $results;
}




?>