#!/usr/bin/perl
$filename = $ARGV[0];

$filename = $filename.'/'.'wifiScanResults.txt';
 open (MYFILE, $filename);
 
 
 $outfile = '>'.$ARGV[0].'/'.'wifiScan_mod.txt';
 open (OUTFILE, $outfile);
 
 while (<MYFILE>) {
 	chomp;
	if( $_ =~ /Configured/)
	{
 		#print "$_\n";
		uptoScan();
		#uptoConfigure();
	}
	else{
		#print 'here';
		#Do Nothing
	}
 }
 close (MYFILE);
close (OUTFILE);
 
sub uptoScan
{
	while(<MYFILE>)
	{
		if( $_ =~ /Scanned/)
                {
                	#print "#Scanned\n";
			uptoConfigure();
			return;

                }
                else
               	{
                	#print "$_\n";
                }

	}
}

sub uptoConfigure
{
	while(<MYFILE>)
	{
		if( $_ =~ /Configure/)
                {
                	#print "$_\n";
			uptoScan();
			return;

                }
                else
               	{
			if( $_ =~ /^\n$/ )
			{
				#Do Nothing
			}
			else
			{
				if( $_ =~ /strongest/ )
				{
				}
				else
				{
                			#print "$_";
					my @values = split(',',$_);

					foreach my $val (@values){
						operateSubStr($val);
						#print "$val\n";
					}
					print OUTFILE "\n";
				}
			}
                }

	}	
}

sub operateSubStr
{
	foreach $item (@_)
	{
		if( $item =~ /SysTime/)
		{
			my @values = split(' ',$item);
			foreach my $val (@values){
				if( $val =~ /SysTime/ )
				{
					next;
				}
				if( $val =~ /=/ )
				{
					next;
				} 
				if( $val =~ /SSID/ )
				{
					next;
				}else
				{ 
					print OUTFILE "$val ";
					
				}
			}
		}elsif ( $item =~ /BSSID/ )
		{
			my @values = split(' ',$item);
			foreach my $val (@values){
				if( $val =~ /BSSID/ )
				{
					next;
				}else{
					
					print OUTFILE "$val ";
					
				}
			}
		}elsif ( $item =~ /level/ )
		{
			my @values = split(' ',$item);
			foreach my $val (@values){
				if( $val =~ /level/ )
				{
					next;
				}else{
					
					print OUTFILE "$val ";
					
				}
			}
		}elsif ( $item =~ /frequency/ )
		{
			my @values = split(' ',$item);
			foreach my $val (@values){
				if( $val =~ /frequency/ )
				{
					next;
				}else{
					
					print OUTFILE "$val ";
					
				}

		}
		}else
		{
			#print "$item\n";
		}
	}	
}
