<?php
error_reporting(-1);
$fid = fopen("folder-id.txt","r");
if(!feof($fid))
{
  $num = intval(fgets($fid));
}
fclose($fid);
//echo $num;

//echo var_dump($_FILES);
echo var_dump($_POST);
echo strcmp($_POST['new'],"yes");

$fid = fopen("folder-id.txt","w");
if(strcmp($_POST['new'],"yes") == 0)
{
$new = $num + 1;	
fwrite($fid,$new."\n");
$numOfFiles = 17;
}
else
{
fwrite($fid,$num."\n");	
$numOfFiles = 4;
}
fclose($fid);

echo "Reached Here";
$n = floor($num);
$target_path = "/home/ananthbalashankar/landmarkerGSoC/Server/www/data/".$n;
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
$i = 1;
echo  "Number of files=".$numOfFiles;
while($i <= $numOfFiles){
$file_path = $target_path . basename( $_FILES["file".$i]['name']);
if(move_uploaded_file($_FILES["file".$i]['tmp_name'], $file_path)) {
 echo "The file ".basename( $_FILES["file".$i]['name']);
} else{
 echo "Server File = ".$_FILES["file".$i]['tmp_name'].", Temp name = ".$file_path;
}
$i =  $i + 1;
}
 
$uid = $_POST['uid'];
//system("export PATH=\$PATH:/usr/local/MATLAB/R2012b/bin/");
if(strcmp($_POST['new'],"yes")==0){
system("sudo /usr/local/MATLAB/R2012b/bin/matlab -nodisplay -nosplash -r \"parsedata('".$target_path."',".$uid.")\" >> ".$target_path."log.out 2>&1");
//echo("matlab -nodisplay -nosplash -r \"parsedata('".$target_path."')\" > ".$target_path."log.out");
}
else
{
system("sudo /usr/local/MATLAB/R2012b/bin/matlab -nodisplay -nosplash -r \"updateLocation('".$target_path."',".$uid.")\" >> ".$target_path."log.out 2>&1");
}  
?>
