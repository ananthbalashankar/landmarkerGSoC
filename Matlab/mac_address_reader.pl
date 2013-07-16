
#!/usr/bin/perl
 open (MYFILE, 'wifiScan_mod.txt');
 while (<MYFILE>) {
 	chomp;
	if( $_ =~ /Scanned/)
	{
 		#print "$_\n";
		uptoScan();
	}
	else{
		#Do Nothing
	}
 }
 close (MYFILE);


sub uptoScan
{
	while(<MYFILE>){
		chomp;
		if( $_ =~ /Scanned/)
		{
		}
		else{
			my @values = split(' ',$_);
			print "@values[0] @values[2]\n";
		}
	}
}
