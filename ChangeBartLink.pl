#!/usr/bin/perl

#******************************************************************************
#
# Filename:	ChangeBartLink.pl
#
# Modify PBS Index JSON file so the link data is the new bartificer.net URL
#
# input:	Index JSON file name
#
# Revision History:
#	04/21/2020     d.rendon     Initial creation
#
#******************************************************************************
use POSIX qw(strftime);
my $version = "1.0";

use JSON;
use Data::Dumper;

# get input. filename from args
#------------------------------------------------------------------------------
# Initialize variables
#------------------------------------------------------------------------------
$filename = $ARGV[0];			# 2nd command line param is links file name

#	init field variables: 
# init vars
$numTopics = 0;
$moduleNum = 0;
#------------------------------------------------------------------------------
# create new output file name (input+"_new")
#------------------------------------------------------------------------------
$idx = rindex($filename,".");
$fname = substr($filename,0,$idx);
$ofilename = $fname."_new.json";

# print new file name
print "Output file name is " . $ofilename . "\n";

# open output file
open (OFILE, ">$ofilename") || die "Cannot open $ofilename: $!\n";

#------------------------------------------------------------------------------
# Main Loop
#------------------------------------------------------------------------------
#=============================================
# Get JSON data
#=============================================
open (INP2,$filename);
@lines = ();
@lines = <INP2>;
$l2 = scalar(@lines);
print "have ".$l2." lines of new data\n";
close (INP2);

$allLinksModified = 0;
# for each line in new data file
foreach (@lines)  {
	chomp;
	$line = $_;
	$line =~ s/\r[\n]*//gm;
	$n++;
	
	# skip any comments
	if (substr($line,0,1) ne ";") {
		# if all links have not been modified, go do link update
		if (!$allLinksModified) {
		
			# remove leading spaces
			$line2 = $line;
			$line2=~ s/^\s+//; 
			
			# extract first 4 chars
			$first4 = substr($line2, 1, 4);
			$first3 = substr($line2, 1, 3);

			# split into 2 strings on first colon
			($keyword,$data) = split(":", $line2, 2);
			$keyword =~ s/\s+$//;		# remove trailing spaces

#			print $line."\n";
#			print "--- ".$first4."; ".$keyword."; ".$data."\n";
#			print "--- ".$first3."\n";

			# if keyword starts with "PBS", get the module number
			if ($first3 eq "PBS") {
				# Extract & set module #
				if (length($keyword) <= 6) {
					$moduleNum = substr($keyword, 4, 1);		# single digit module number
				} else {
					$moduleNum = substr($keyword, 4, 2);
				}

			# else if keyword is "Link", replace with updated link format
			} elsif ($first4 eq "Link"){
				# if data contains "bartbusschots"
				if (index ($data, "bartbusschots") > 0) {
					# make new link line: https://pbs.bartificer.net/pbs{module #}.html
					$line = "                                   ".
						"\"Link\" : ".
						"\"https://pbs.bartificer.net/pbs".$moduleNum.".html\",";
					print $line."\n";
				}		# end if

			# else if keyword is "Topics", set no more links to modify
			} elsif ($first4 eq "Topi"){
				$allLinksModified = 1;		# set flag: all links modified
			}			# endif
		}
		# write line to output file
		print OFILE $line."\n";
	}
}		# end foreach

close OFILE;					# close output file

#------------------------------------------------------------------------------
# exit
#------------------------------------------------------------------------------
printf "From Perl script version ".$version."\n";
printf "All done! Bye bye!\n";
exit 0
#
#******************************************************************************
# Subroutines
#******************************************************************************
