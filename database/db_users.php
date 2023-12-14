<?php
include(__DIR__."/../init.php");

class DBUsers
{
    private $db;

    public function __construct()
    {
        global $db;
        $this->db = $db;
    }

    public function insertUser($name, $photoPath, $roleId, $birthdate, $location, $phoneNumber, $email, $passwordHash, $verificationNum, $verified)
    {
        // Validate required fields
        if (empty($name) || empty($email) || empty($passwordHash)) {
            return false; // Return false if any required field is empty
        }

        $query = "INSERT INTO users (name, photo_path, role_id, birthdate, location, phone_number, email, password_hash, verification_num, verified) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $this->db->query($query, $name, $photoPath, $roleId, $birthdate, $location, $phoneNumber, $email, $passwordHash, $verificationNum, $verified);
        return $this->db->affectedRows() > 0;
    }


    public function deleteUser($userId)
    {
        $query = "DELETE FROM users WHERE id = ?";
        $this->db->query($query, $userId);

        return $this->db->affectedRows() > 0;
    }

    public function updateUser($userId, $name, $photoPath, $roleId, $birthdate, $location, $phoneNumber, $email, $passwordHash, $verificationNum, $verified)
    {
        $query = "UPDATE users SET name=?, photo_path=?, role_id=?, birthdate=?, location=?, phone_number=?, email=?, password_hash=?, verification_num=?, verified=? WHERE id=?";
        $this->db->query($query, $name, $photoPath, $roleId, $birthdate, $location, $phoneNumber, $email, $passwordHash, $verificationNum, $verified, $userId);

        return $this->db->affectedRows() > 0;
    }

    public function getUserByEmail($email)
    {
        $query = "SELECT * FROM users WHERE email = ?";
        $result = $this->db->query($query, $email);

        if ($result->numRows() > 0) {
            return $result->fetchArray();
        } else {
            return null;
        }
    }
}


?>