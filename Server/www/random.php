<?php

$val1 = "\n".$_POST["Lat"] ;

$myFile = "testFile.txt";
$fh = fopen($myFile, 'a');
fwrite($fh , $val1);
fclose($fh);
?>