<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'vendor/autoload.php'; // Adjust the path if necessary

function sendVerificationCode($email, $verificationCode) {
    $mail = new PHPMailer(true);

    try {
        //Server settings
        $mail->isSMTP();
        $mail->Host = 'smtp.gmail.com';  //gmail SMTP server
        $mail->SMTPAuth = true;
        //to view proper logging details for success and error messages
        // $mail->SMTPDebug = 1;
        $mail->Host = 'smtp.gmail.com';  //gmail SMTP server
        $mail->Username = 'hamzabennz11@gmail.com';   //email
        $mail->Password = 'qeey kprh iglh cvor' ;   //16 character obtained from app password created
        $mail->Port = 465;                    //SMTP port
        $mail->SMTPSecure = "ssl";


        //Recipients
        $mail->setFrom('hamzabennz11@gmail.com', 'Hamza Benzaoui');
        $mail->addAddress($email);

        //Content
        $mail->isHTML(true);
        $mail->Subject = 'Verification Code';
        $mail->Body    = "Your verification code is: $verificationCode";

        $mail->send();
        echo 'Verification code email sent successfully';
    } catch (Exception $e) {
        echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
    }
}

function generateVerificationCode() {
    return mt_rand(1000, 9999); // Generate a random 4-digit code
}


?>
