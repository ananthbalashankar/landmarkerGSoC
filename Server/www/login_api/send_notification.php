#!/usr/bin/php
<?php

require_once 'include/DB_Functions.php';
include_once './GCM.php';
echo "starting at ".date('Y/m/d H:i:s')."\n";
    
    try{
    $db = new DB_Functions();
    $gcm = new GCM();
    $users = $db->getAllUsers();
    $file = "logfile.txt";
    
    while ($row = mysql_fetch_array($users)) {
	try{
		echo $row["sent_at"]."\n";
		$date1 = strtotime($row["updated_at"]);
		$date2 = strtotime($row["sent_at"]);
		if($date1 > $date2)
		{
			$str = file_get_contents('../../../Matlab/stable/notifications_'.$row["uid"].'.txt');
			$arr = explode("\n",$str);
			for($i=0;$i<count($arr);$i++)
			{
				$registatoin_ids = array($row["gcm_regid"]);
				$message = array("price" => $arr[$i]);

				$result = $gcm->send_notification($registatoin_ids, $message);
				$message .= "\n";
				file_put_contents($file,$message,FILE_APPEND | LOCK_EX);
				echo $message;

			}
			$result = mysql_query("Update table users set sent_at=NOW() where uid=".$row["uid"]);
		}
	}
	catch(Exception $e1)
	{
		file_put_contents($file,'Caught exception: '.$e1->getMessage().'\n',FILE_APPEND | LOCK_EX);
		echo 'Caught exception: '.$e1->getMessage().'\n';
		continue;
	}	

	}
    }
	catch(Exception $e)
	{
		file_put_contents($file,'Caught exception: '.$e->getMessage().'\n',FILE_APPEND | LOCK_EX);
		echo 'Caught exception: '.$e->getMessage().'\n';
	}


?>
