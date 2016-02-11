<?php

//    $deviceToken = htmlspecialchars($_GET["token"]) ;
    
//echo $deviceToken;
//    
//    echo "---->";
    
$sandbox = $_POST['sandbox'];

$deviceToken = $_POST['registrationIDs'];
    
$passphrase = '123456';

$message = $_POST['message'];

    $ctype = $_POST['ctype'];
    
    $cid = $_POST['cid'];
    
$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
    
    if (strlen($sandbox) == 0)
    {
        $fp = stream_socket_client(
                                   'ssl://gateway.sandbox.push.apple.com:2195', $err,
                                   $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);
    }
    else
    {
        $fp = stream_socket_client(
                                   'ssl://gateway.push.apple.com:2195', $err,
                                   $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);
    }
    
//$fp = stream_socket_client(
//'ssl://gateway.push.apple.com:2195', $err,
//$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
//$body['aps'] = array(
//	'alert' => $message,
//	'sound' => 'default',
//	'badge' => '1'
//);
    
    $json = json_encode(array(
                              "aps" => array(
                                             'alert' => $message,
                                             'sound' => 'default',
                                             'badge' => '1'
                                                ),
                              "content-available" => '1',
                              "ctype" => $ctype,
                              "cntid" => $cid

//                              "data" => array(
//                                              "distributorId" => "xxxx",
//                                              "distributorPin" => "xxxx",
//                                              "locale" => "en-US"
//                                              )
                              ));

// Encode the payload as JSON
    $payload = $json;//json_encode($mess);
// for($i=0;$i<2;$i++)
// {
// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) .     $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));
echo "msg may be delivered";
// }
