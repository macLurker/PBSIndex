#!/usr/bin/perl

#******************************************************************************
#
# Filename:	updatePBSJSON.pl
#
# Update PBS JSON file with a new lesson module. Read input from a file (PBSIndexNewData.txt)
#
# input: New Index data file name
#		 Index JSON file name
#
# Revision History:
#	05/28/19     d.rendon     Initial creation
#	02/24/20.    d.rendon     Update for Bart's new URL pattern
#	01/05/23     d.rendon     Add check on input file open
#
#******************************************************************************
use POSIX qw(strftime);
my $version = "1.3";

use JSON;
use Data::Dumper;

# get input. filename from args
#------------------------------------------------------------------------------
# Initialize variables
#------------------------------------------------------------------------------
$newdataFilename = $ARGV[0];	# 1st command line param is text file with new data
$filename = $ARGV[1];			# 2nd command line param is links file name

#	init field variables: 
# init vars
$numTopics = 0;
#@topics = [];

#=============================================
# Get current JSON from data file
#=============================================
# Suck in file data into string
# Get input from data file
#open (INP,$filename);
open (INP,$filename) or die "Unable to open JSON data file ".$filename."\n <<";

@lines = ();
@lines = <INP>;
$l = scalar(@lines);
print "have ".$l." JSON lines\n";
close (INP);

# convert to perl Object $json = '{"a":1,"b":2,"c":3,"d":4,"e":5}';
$json = join("",@lines);			# combine all lines into one string
$pobj = from_json($json);			# convert JSON text into Perl object

#------------------------------------------------------------------------------
# Main Loop
#------------------------------------------------------------------------------
#=============================================
# Get new index data from data file
#=============================================
#open (INP2,$newdataFilename);
open (INP2,$newdataFilename) or die "Unable to open new data file ".$newdataFilename."\n <<";

@lines = ();
@lines = <INP2>;
$l2 = scalar(@lines);
print "have ".$l2." lines of new data\n";
close (INP2);

# for each line in new data file
foreach (@lines)  {
	chomp;
	$line = $_;
	$line =~ s/\r[\n]*//gm;
	$n++;
	
	# skip any comments
	if (substr($line,0,1) ne ";") {
		($kw2,$data) = split(":", $line);
		$keyword = lc($kw2);		# convert to lower case
		
		if ($keyword eq "pbsmodule") {		# must be first line
			$moduleNum = $data;
		} elsif ($keyword eq "pbstitle") {
			$lessonTitle = $data;
		} elsif ($keyword eq "pbsdate") {
			$urlDate = $data;
		} elsif ($keyword eq "pbsurltitle") {
			$urlTitle = $data;
		} elsif ($keyword eq "pbstopic") {
			push @topics,$data;		# push on topics array
			$numTopics++;				# increment # new topics
		} elsif ($keyword eq "pbsend") {
			last;		
		}
	}
}		# end foreach

$module = "PBS".$moduleNum;
$title = "PBS ".$moduleNum." of X &#8211; ".$lessonTitle;
#$link = "https://www.bartbusschots.ie/s/2019/".$urlDate."/pbs-".$moduleNum."-of-x-".$urlTitle;
$link = "https://pbs.bartificer.net/pbs".$moduleNum.".html";

print "New module is ".$module."\n";
print "New title is  ".$title."\n";
print "New URL is    ".$link."\n\n";

print "Number of new topics is ".$numTopics."\n";		# print # new topics
# verify at least one topic entered
if ($numTopics <= 0) {
	die "No index topics found in file. Must have at least one";
}

#=============================================
# Add input to Perl Object
#=============================================
# set key to module name
$key = $module;

# add module title & link to Lesson sub-object
$lrec = {Title=>$title,Link=>$link};
$pobj->{Lessons}->{$key} = $lrec;

# add module to Topics sub-object, with topic as key
# foreach new topic
foreach $topic ( @topics ) {
	# set key to topic string
	# add module name to Topics sub-object
	$pobj->{Topics}->{$topic}->{Key} = $module;
}		# end for

# modify version info in Perl object with current date/time
# format -> dd mmm yyyy, hh:mm
$datestring = strftime "%e %b %Y, %H:%M", localtime;
printf("date and time - $datestring\n");
$pobj->{"DataVersion"} = $datestring;

#=============================================
# Convert back to JSON text
#=============================================

# convert Perl object to JSON text
$Data::Dumper::Useqq = 1;        # print strings in double quotes
$Data::Dumper::Pair = ' : ';	 # specify the separator between hash keys and values
$Data::Dumper::Varname = "";	 # skip leading VAR name
$Data::Dumper::Sortkeys = 1;	 # sort hash keys

$outText = Dumper($pobj);
$ot = substr($outText,index($outText,"=")+2);	# remove leading variable name (put therm by Dumper
$ot2 = substr($ot,0,rindex($ot,";"));		# remove trailing semi

$json_new = $ot2;

#=============================================
# Write to new output file
#=============================================
# create new output file name (input+"_new")
$idx = rindex($filename,".");
$fname = substr($filename,0,$idx);
$ofilename = $fname."_new.json";

# print new file name
print "Output file name is " . $ofilename . "\n";

# open output file
open (OFILE, ">$ofilename") || die "Cannot open $ofilename: $!\n";

# write JSON string to file
print OFILE $json_new."\n";

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
