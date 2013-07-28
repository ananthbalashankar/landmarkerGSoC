<?php


function streamFile($location, $filename, $mimeType='application/octet-stream')
{ if(!file_exists($location))
  { header ("HTTP/1.0 404 Not Found");
    return;
  }
  
  $size=filesize($location);
  $time=date('r',filemtime($location));
  #html response header
  header('Content-Description: File Transfer');	
  header("Content-Type: $mimeType"); 
  header('Cache-Control: public, must-revalidate, max-age=0');
  header('Pragma: no-cache');  
  header('Accept-Ranges: bytes');
  header('Content-Length:'.($size));
  header("Content-Disposition: inline; filename=$filename");
  header("Content-Transfer-Encoding: binary\n");
  header("Last-Modified: $time");
  header('Connection: close');      

  ob_clean();
  flush();
  readfile($location);	
}

$fid = fopen("folder-id.txt","r");
if(!feof($fid))
{
  $num = fgets($fid);
}
fclose($fid);
//echo $num;
$num+=1;

$fid = fopen("folder-id.txt","w");
fwrite($fid,$num."\n");
fclose($fid);

$n = floor($num/14);
$target_path  = "data/".$n;
$target_path=$target_path;
//echo $target_path;
$save = umask(0);
if (mkdir($target_path)) chmod($target_path, 0755);
umask($save);
$target_path .= "/";
//echo $num;
$target_path = $target_path . basename( $_FILES['uploadedfile']['name']);


$processed_photo_output_path = "./";
$downloadFileName = 'Cover.jpg'; 
$processed_photo_output_path = $processed_photo_output_path. $downloadFileName ;
//$processed_photo_output_path = $processed_photo_output_path. basename( $_FILES['uploadedfile']['name']); 
//$downloadFileName = 'processed_' . basename( $_FILES['uploadedfile']['name']); 
if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) {
 echo "The file ".  basename( $_FILES['uploadedfile']['name']).
 " has been uploaded";
} else{
 echo "Filename=".$_FILES['uploadedfile']['name']."ServerName=".$target_path." an error uploading the file, please try again!";}
 
 
// streamFile($processed_photo_output_path, $downloadFileName,"application/octet-stream");*/

?>
