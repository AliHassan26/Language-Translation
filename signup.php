<?php
include 'db.php';

// Allow cross-origin requests
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = htmlspecialchars($_POST['name']);
    $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
    $password = password_hash($_POST['password'], PASSWORD_BCRYPT);

    try {
        $stmt = $conn->prepare("INSERT INTO users (name, email, password) VALUES (:name, :email, :password)");
        $stmt->bindParam(':name', $name);
        $stmt->bindParam(':email', $email);
        $stmt->bindParam(':password', $password);
        $stmt->execute();

        echo json_encode(["success" => true, "message" => "User registered successfully!"]);
    } catch (PDOException $e) {
        if ($e->getCode() === '23000') { // Unique constraint violation
            echo json_encode(["success" => false, "message" => "Email already registered."]);
        } else {
            error_log($e->getMessage(), 3, "/var/log/php_errors.log");
            echo json_encode(["success" => false, "message" => "Server error."]);
        }
    }
}
?>
