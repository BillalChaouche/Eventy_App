<?php

include("init.php");

function insertEvent($data)
{
    global $db;

    // Sanitize input (consider using prepared statements)
    $title = $data['title'];
    $imagePath = $data['imagePath'] ?? null;
    $date = $data['date'];
    $time = $data['time'];
    $description = $data['description'] ?? null;
    $attendees = $data['attendees'] ?? null;
    $location = $data['location'] ?? null;
    $organizer_id = $data['organizer_id'];
    $category_id = $data['category_id'];

    // Insert into the events table
    $sql = "INSERT INTO events (title, imagePath, date, time, description, attendees, location, organizer_id, category_id)
            VALUES ('$title', '$imagePath', '$date', '$time', '$description', '$attendees', '$location', '$organizer_id', '$category_id')";

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
    $date = $data['date'];
    $time = $data['time'];
    $description = $data['description'] ?? null;
    $attendees = $data['attendees'] ?? null;
    $location = $data['location'] ?? null;
    $organizer_id = $data['organizer_id'];
    $category_id = $data['category_id'];


    // Update the event in the events table 
    $sql = "UPDATE events 
            SET title = '$title', 
                imagePath = '$imagePath', 
                date = '$date', 
                time = '$time', 
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



?>