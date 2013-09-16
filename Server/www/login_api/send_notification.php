#!/usr/bin/php
<?php
error_reporting(-1);
set_include_path('/home/swadhin/Landmark/landmarkerGSoC/Server/www/login_api/');
require_once 'include/DB_Functions.php';
include_once 'GCM.php';
echo "starting at ".date('Y/m/d H:i:s')."\n";
    
    try{
    $db = new DB_Functions();
    $gcm = new GCM();
    $users = $db->getAllUsers();
    $file = "logfile.txt";
    
    while ($row = mysql_fetch_array($users)) {
	try{
		echo $row['uid']."\n";
		$date1 = strtotime($row["updated_at"]);
		$date2 = strtotime($row["sent_at"]);
		echo $date1;
		echo $date2;	
		if(!is_null($date1) && ($date1 > $date2 || is_null($date2)))
		{
			$str = file_get_contents('/home/swadhin/Landmark/landmarkerGSoC/Matlab/stable/notifications_'.$row["uid"].'.txt');
			echo $str;
			$arr = explode("\n",$str);
			for($i=0;$i<count($arr);$i++)
			{
				$registatoin_ids = array($row["gcm_regid"]);
				$message = array("price" => $arr[$i]);
				echo "sending ".$row["gcm_regid"]." ,user=".$row["uid"].",message = ".$arr[$i]."\n";
				$result = $gcm->send_notification($registatoin_ids, $message);
				$result .= "\n";
				file_put_contents($file,$result,FILE_APPEND | LOCK_EX);
				echo $result;

			}
			$result = $db->execQuery("Update users set sent_at=NOW() where uid=".$row["uid"]);
			echo "sent=".$result."\n";
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
