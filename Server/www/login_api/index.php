<?php
session_start();
if(!isset($_SESSION['username'])) {
/**
 * File to handle all API requests
 * Accepts GET and POST
 * 
 * Each request will be identified by TAG
 * Response will be JSON data

  /**
 * check for POST request 
 */
//echo phpinfo();
if (isset($_POST['tag']) && $_POST['tag'] != '') {
    // get tag
    
    $tag = $_POST['tag'];
	
    // include db handler
    require_once 'include/DB_Functions.php';
    try{
	
    $db = new DB_Functions();
    //echo "there";
	}
	catch(Exception $e)
	{
		echo 'Caught exception: ',  $e->getMessage(), "\n";
		
	}

    // response Array
    $response = array("tag" => $tag, "success" => 0, "error" => 0);
	//echo "register";

    // check for tag type
    if ($tag == 'login') {
        // Request type is check Login
        $email = $_POST['email'];
        $password = $_POST['password'];

        // check for user
        $user = $db->getUserByEmailAndPassword($email, $password);
        if ($user != false) {
            // user found
            // echo json with success = 1
            $response["success"] = 1;
            $response["uid"] = $user["uid"];
            $response["user"]["name"] = $user["username"];
            $response["user"]["phone"] = $user["phone"];
            $response["user"]["created_at"] = $user["created_at"];

            //$response["user"]["updated_at"] = $user["updated_at"];
            
            $_SESSION["uid"] = $user["uid"];
			$_SESSION["username"] = $user["username"];
			$_SESSION["phone"] = $user["phone"];
			$_SESSION["created_at"] = $user["created_at"];
                
            
            echo json_encode($response);
        } else {
            // user not found
            // echo json with error = 1
            $response["error"] = 1;
            $response["error_msg"] = "Incorrect email or password!";
            echo json_encode($response);
        }
    } else if ($tag == 'register') {
        // Request type is Register new user
        $name = $_POST['name'];
        $email = $_POST['email'];
        $password = $_POST['password'];
	$gcm_regid = $_POST["regId"];
		

        // check if user is already existed
	//echo $gcm_regid;
        if ($db->isUserExisted($email)) {
            // user is already existed - error response
            $response["error"] = 2;
            $response["error_msg"] = "User already existed";
            //echo "User already existed";
            echo json_encode($response);
        } else {
            // store user
	    
            $user = $db->storeUser($email,$name,$password,$gcm_regid);
            if ($user) {
                // user stored successfully

                $response["success"] = 1;
                $response["uid"] = $user["uid"];
                $response["user"]["name"] = $user["username"];
                $response["user"]["email"] = $user["phone"];
                $response["user"]["created_at"] = $user["created_at"];
		
                
                $_SESSION["uid"] = $user["uid"];
                $_SESSION["username"] = $user["username"];
                $_SESSION["phone"] = $user["phone"];
                $_SESSION["created_at"] = $user["created_at"];
		$_SESSION["gcm_regid"] = $user["gcm_regid"];
                
		include_once './GCM.php';
		$gcm = new GCM();
		$registatoin_ids = array($gcm_regid);
		$message = array("product" => "shirt");
		$result = $gcm->send_notification($registatoin_ids, $message);

	
		
                echo json_encode($response);
            } else {
                // user failed to store
                $response["error"] = 1;
                $response["error_msg"] = "Error occured in Registartion";
                //echo mysqli_error($this->db_link);
                echo json_encode($response);
            }
        }
    } else {
        echo "Invalid Request";
    }
} else {
    echo "Access Denied";
}
}
else
{
	$response["success"] = 1;
	$response["uid"] = $_SESSION["uid"];
	$response["user"]["name"] = $_SESSION["username"];
	$response["user"]["email"] = $_SESSION["phone"];
	$response["user"]["created_at"] = $_SESSION["created_at"];
	echo json_encode($response);
}
?>
