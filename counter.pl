#!/usr/bin/env perl

#
# Report on data produced by wc.pl (output file: wordstats.json) 
# with search terms passed on the command line.
#
# 2013-12-21 Matthew Smith <matt@smiffytech.com>
#

use strict;
use warnings;
use JSON;
use Data::Dumper;

# Tweets file to process
my $datafile = 'wordstats.json';

open IN, $datafile or die($!);
my $json = join("", <IN>);
close IN;

my $jdata = decode_json $json;


my @terms = @ARGV;

unless (scalar @terms) {
  print "Usage: counter.pl term1 term2 term3 ... termN\n";
  exit;
}

# First loop - add hashtags to any non-hashtag items.
for my $term (@terms) {
  next if $term =~ /^[@#]/;
  push(@terms, '#' . $term);
}

my $total = 0;
my $output = '';

for my $term (sort @terms) {
  if (defined $jdata->{$term}) {
    $output .= "$term: $jdata->{$term}\n";

    $total += $jdata->{$term};
  } 
}

$output .= "\nTOTAL: $total\n";

print "\n\n" . $output . "\n\nReport length: " . length($output) . "\n";
