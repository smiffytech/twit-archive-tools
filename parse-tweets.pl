#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use File::Slurp;
use JSON;

# Use UTF8 mode so we don't get wide character warnings.
use open qw(:std :utf8);

# Check we've been given an input file.
unless ($ARGV[0]) {
    print STDERR "Usage: parse-tweets.pl INPUT_FILE\n";
    exit 1;
}

# File must exist.
unless (-f $ARGV[0]) {
    print STDERR sprintf("%s is not a valid file.\n", $ARGV[0]);
    exit 1;
}

# Read in file useing File::Slurp::read_file().
my $json = read_file($ARGV[0]);

# Didn't we see anything?
unless ($json) {
    print STDERR sprintf("Failed to get input from %s\n", $ARGV[0]);
    exit 1;
}

# Decode the JSON.
my $data = decode_json $json;

# Change the file extension of the input file
# to CSV for output.
my $outfile = $ARGV[0];
$outfile =~ s/\.\w+/\.csv/;
open(my $fh, ">", $outfile);

# Iterate through all the records. Each one contains a structure
# called tweet.
for my $record (@$data) {

    # Uncomment the next line to dump off the record structure.
    # print Dumper $record->{'tweet'}; exit;

    print $fh sprintf("%s,\"%s\",\"%s\"\n", 
        $record->{'tweet'}{'id'}, 
        $record->{'tweet'}{'created_at'}, 
        $record->{'tweet'}{'full_text'});
}

close $fh;

printf("Tweets written to %s\n", $outfile);
