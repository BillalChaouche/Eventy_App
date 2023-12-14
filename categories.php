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
    case "categories.get": {
        $items = $db->query("SELECT * FROM categories")->fetchAll();
        echo json_encode ($items);
        exit;
    }
}
?>
