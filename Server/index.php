<?php

$val1 = $_GET["var1"] ;
$val2 = $_GET["var2"];
$myFile = "testFile.txt";
$command = "matlab -nojvm -nodesktop -nodisplay -r findmax(".$val1.",".$val2.",'".$myFile."')";
//echo $command;
exec($command);
sleep(4);

$fh = fopen($myFile, 'r');
$theData = fgets($fh);
fclose($fh);
echo $theData;




?>