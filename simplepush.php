<?php

    $deviceToken = htmlspecialchars($_GET["token"]) ;
    
echo $deviceToken;
    
    echo "---->";
    
$passphrase = '123456';

$message = 'Push notification test done!';

////////////////////////////////////////////////////////////////////////////////

// $ctx = stream_context_create();
// stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck.pem');
// stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);
//
// // Open a connection to the APNS server
// $fp = stream_socket_client(
	// 'ssl://gateway.push.apple.com:2195', $err,
	// $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);
//
// if (!$fp)
	// exit("Failed to connect: $err $errstr" . PHP_EOL);
//
// echo 'Connected to APNS' . PHP_EOL;
//
// // Create the payload body
// $body['aps'] = array(
	// 'alert' => $message,
	// 'sound' => 'default',
	// 'badge' => '+1'
	// );
//
// // Encode the payload as JSON
// $payload = json_encode($body);
//
// // Build the binary notification
// $msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;
//
// // Send it to the server
// $result = fwrite($fp, $msg, strlen($msg));
//
// if (!$result)
	// echo 'Message not delivered' . PHP_EOL;
// else
	// echo 'Message successfully delivered' . PHP_EOL;
//
// // Close the connection to the server
// fclose($fp);
//
// <?php
// // Put your device token here (without spaces):
// $deviceToken[0] = '92a15ad893a518258b8807edb8a76044c3ef9dd28008461b4289a2dde7ddc4de';
//
// $deviceToken[1] = '92a15ad893a518258b8807edb8a76044c3ef9dd28008461b4289a2dde7ddc4de';
//
// // Put your private key's passphrase here:
// $passphrase = '1234567';
//
// // Put your alert message here:
// $message = 'multiple device push notification...!';

////////////////////////////////////////////////////////////////////////////////

$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
$fp = stream_socket_client(
'ssl://gateway.push.apple.com:2195', $err,
$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
$body['aps'] = array(
	'alert' => $message,
	'sound' => 'default',
	'badge' => '1'
);

// Encode the payload as JSON
$payload = json_encode($body);
// for($i=0;$i<2;$i++)
// {
// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) .     $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));
echo "msg may be delivered";
// }
