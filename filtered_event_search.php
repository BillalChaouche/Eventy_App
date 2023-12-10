<?php

include("./database/db_events.php");

// Read JSON input from the request
$json_input = file_get_contents('php://input');
$data = json_decode($json_input, true);

// Call the filteredSearch function and capture the results
$filteredEvents = filteredSearch($data);

// Return the results as JSON
header('Content-Type: application/json');
echo json_encode($filteredEvents);
exit;



?>
