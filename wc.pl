#!/usr/bin/env perl

#
# Parse any of the text-* files produced by
# masher.pl to produce a word-count JSON document.
#
# 2013-12-21 Matthew Smith <matt@smiffytech.com>
#

use strict;
use warnings;
use JSON;
use Data::Dumper;

# Tweets file to process
my $datafile = 'text-all.json';

open IN, $datafile or die($!);
my $json = join("", <IN>);
close IN;

my $jdata = decode_json $json;

my $worddb;

my $counter = 0;
my $wordcount = 0;
my $distinct_words = 0;
my $links = 0;
my $tfrom = time();


for my $tweet (@$jdata) {
  $counter++;

  my @words = split(/\s+/, $tweet);

  for my $word (@words) {
    my $lcword = lc($word);

    # Slashes are confusing - we don't know
    # what they might mean in context. Skip.
    next if $lcword =~ /\//;

    # Strip off anything that might be
    # punctuation, but preserve things 
    # like units (eg: degrees.)
    $lcword =~ s/^[^a-zA-Z0-9 \-_#@]+//;
    $lcword =~ s/[^a-zA-Z0-9 \-_#@°]+$//;

    $lcword =~ s/'s$//;

    $lcword =~ s/^\-$//g;

    next unless $lcword;

    $wordcount++;
    if ($lcword =~ /^http:\/\//) {
      $links++;
      next;
    }

    if (defined $worddb->{$lcword}) {
      $worddb->{$lcword}++;
    } else {
      $distinct_words++;
      $worddb->{$lcword} = 1;
    }
  }
}

open OUT, '>', 'wordstats.json';
print OUT to_json($worddb, { pretty => 1, utf8 => 1 });
close OUT;

my $duration = time() - $tfrom;
print "$counter tweets with total $wordcount words, $distinct_words distinct words processed in $duration seconds.\n";


