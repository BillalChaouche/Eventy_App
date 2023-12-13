<?php

include(__DIR__ . "/../init.php");

class DBOrganizers
{
    private $db;

    public function __construct()
    {
        global $db;
        $this->db = $db;
    }

    public function insertOrganizer($name, $photoPath, $roleId, $birthdate, $location, $phoneNumber, $email, $passwordHash, $verificationNum, $verified)
    {
        // Insert into the organizers table
        $sql = "INSERT INTO organizers (name, photo_path, role_id, birthdate, location, phone_number, email, password_hash, verification_num, verified) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $this->db->query($sql, $name, $photoPath, $roleId, $birthdate, $location, $phoneNumber, $email, $passwordHash, $verificationNum, $verified);

        // Check for errors
        if ($this->db->affectedRows() > 0) {
            // Successful insertion
            return ['success' => 'Organizer inserted successfully'];
        } else {
            // Error during insertion
            return ['error' => 'Failed to insert organizer'];
        }
    }


    public function selectOrganizer($organizerID)
    {
        // Build the SQL query to select an organizer by ID
        $sql = "SELECT * FROM organizers WHERE id = $organizerID";

        // Execute the query and fetch the result
        $result = $this->db->query($sql)->fetchAll();

        return $result;
    }

    public function updateOrganizer($organizerID, $data)
    {
        // Sanitize input (consider using prepared statements)
        $name = $data['name'];
        $photoPath = $data['photoPath'] ?? null;
        $roleId = $data['role_id'] ?? null;
        $birthdate = $data['birthdate'] ?? null;
        $location = $data['location'] ?? null;
        $phoneNumber = $data['phone_number'] ?? null;
        $email = $data['email'];
        $passwordHash = $data['password_hash'];
        $verificationNum = $data['verification_num'] ?? null;
        $verified = $data['verified'] ?? 0;

        // Update the organizer in the organizers table 
        $sql = "UPDATE organizers 
                SET name = '$name', 
                    photo_path = '$photoPath', 
                    role_id = '$roleId', 
                    birthdate = '$birthdate', 
                    location = '$location', 
                    phone_number = '$phoneNumber', 
                    email = '$email', 
                    password_hash = '$passwordHash', 
                    verification_num = '$verificationNum', 
                    verified = '$verified'
                WHERE id = '$organizerID'";

        // Execute the query
        $this->db->query($sql);

        // Check for errors
        if ($this->db->affectedRows() > 0) {
            // Successful update
            return ['success' => 'Organizer updated successfully'];
        } else {
            // Error during update
            return ['error' => 'Failed to update organizer'];
        }
    }

    public function deleteOrganizer($organizerID)
    {
        // Delete the organizer
        $sql = "DELETE FROM organizers WHERE id = '$organizerID'";
        $this->db->query($sql);

        // Check for errors
        if ($this->db->affectedRows() > 0) {
            // Successful deletion
            return ['success' => 'Organizer deleted successfully'];
        } else {
            // Error during deletion
            return ['error' => 'Failed to delete organizer'];
        }
    }

    public function getOrganizerByEmail($email)
    {
        // Build the SQL query to select an organizer by email
        $sql = "SELECT * FROM organizers WHERE email = '$email'";

        // Execute the query and fetch the result
        $result = $this->db->query($sql)->fetchArray();

        return $result;
    }
}



?>