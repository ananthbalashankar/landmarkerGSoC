<?php


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

echo "Reached Here";
$n = floor($num);
$target_path  = "/var/www/data/".$n;
$target_path=$target_path;
echo $target_path;
$save = umask(0);
if (mkdir($target_path)) chmod($target_path, 0777);
umask($save);
$target_path .= "/";
//echo $num;

//var_dump($_FILES);

//echo "Reached Here";

//$files = array('file1','file2');//'file3','file4','file5','file6','file7','file8','file9','file10','file11','file12','file13','file14');

$file_path = $target_path . basename( $_FILES["file1"]['name']);
if(move_uploaded_file($_FILES["file1"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file1"]['name']);
} else{
 echo "Server File = ".$_FILES["file1"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file2"]['name']);
if(move_uploaded_file($_FILES["file2"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file2"]['name']);
} else{
 echo "Server File = ".$_FILES["file2"]['tmp_name'].", Temp name = ".$file_path;
}


$file_path = $target_path . basename( $_FILES["file3"]['name']);
if(move_uploaded_file($_FILES["file3"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file3"]['name']);
} else{
 echo "Server File = ".$_FILES["file3"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file4"]['name']);
if(move_uploaded_file($_FILES["file5"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file5"]['name']);
} else{
 echo "Server File = ".$_FILES["file5"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file6"]['name']);
if(move_uploaded_file($_FILES["file6"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file6"]['name']);
} else{
 echo "Server File = ".$_FILES["file6"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file7"]['name']);
if(move_uploaded_file($_FILES["file7"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file7"]['name']);
} else{
 echo "Server File = ".$_FILES["file7"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file8"]['name']);
if(move_uploaded_file($_FILES["file8"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file8"]['name']);
} else{
 echo "Server File = ".$_FILES["file8"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file9"]['name']);
if(move_uploaded_file($_FILES["file9"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file9"]['name']);
} else{
 echo "Server File = ".$_FILES["file9"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file10"]['name']);
if(move_uploaded_file($_FILES["file10"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file10"]['name']);
} else{
 echo "Server File = ".$_FILES["file10"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file11"]['name']);
if(move_uploaded_file($_FILES["file11"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file11"]['name']);
} else{
 echo "Server File = ".$_FILES["file11"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file12"]['name']);
if(move_uploaded_file($_FILES["file12"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file12"]['name']);
} else{
 echo "Server File = ".$_FILES["file12"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file13"]['name']);
if(move_uploaded_file($_FILES["file13"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file13"]['name']);
} else{
 echo "Server File = ".$_FILES["file13"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file14"]['name']);
if(move_uploaded_file($_FILES["file14"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file14"]['name']);
} else{
 echo "Server File = ".$_FILES["file14"]['tmp_name'].", Temp name = ".$file_path;
}


$file_path = $target_path . basename( $_FILES["file15"]['name']);
if(move_uploaded_file($_FILES["file15"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file15"]['name']);
} else{
 echo "Server File = ".$_FILES["file15"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file16"]['name']);
if(move_uploaded_file($_FILES["file16"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file16"]['name']);
} else{
 echo "Server File = ".$_FILES["file16"]['tmp_name'].", Temp name = ".$file_path;
}

$file_path = $target_path . basename( $_FILES["file17"]['name']);
if(move_uploaded_file($_FILES["file17"]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILE["file17"]['name']);
} else{
 echo "Server File = ".$_FILES["file17"]['tmp_name'].", Temp name = ".$file_path;
}
//system("export PATH=\$PATH:/usr/local/MATLAB/R2012b/bin/");
system("sudo /usr/local/MATLAB/R2012b/bin/matlab -nodisplay -nosplash -r \"parsedata('".$target_path."')\" > ".$target_path."log.out");
echo("matlab -nodisplay -nosplash -r \"parsedata('".$target_path."')\" > ".$target_path."log.out");
?>
