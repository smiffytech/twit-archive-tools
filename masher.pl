#!/usr/bin/env perl

#
# Perl script to read a directory of monthly Twitter
# archive files into a single JSON file.
#
# 2013-12-21 Matthew Smith <matt@smiffytech.com>
#
# How to use: 
#
# Unzip Twitter archive, put this file in data/js/tweets
# subdirectory, invoke as ./masher.pl
#

use strict;
use warnings;
use JSON;
use Data::Dumper;

# Grab list of all files in this directory.
my @files = glob("./*");

# Initialise empty arrayref.
my $jdata = [];
my $text_all = [];
my $text_replies = [];
my $text_noreplies = [];

# Stats stuff.
my $counter = 0;
my $tweets = 0;
my $replies = 0;
my $tfrom = time();

for my $f (@files) {
  # Don't process anything but .js files.
  next unless $f =~ /\.js$/;

  $counter++;

  # Read JSON from file into string.
  open IN, $f;
  my $raw = join("", <IN>);
  close IN;
  my $js;

  # JSON actually declared as a JavaScript
  # object - need to strip the assignment
  # from the start of the file.
  (undef, $js) = split(/=/, $raw, 2);

  # Each month is an array, so traverse the
  # array and push each member to our arrayref.
  my $mdata = decode_json $js;

  for my $tweet (@$mdata) {
    $tweets++;
    if ($tweet->{'text'} =~ /^@/) {
      $replies++;
      push(@{$text_replies}, $tweet->{'text'});
    } else {
      push(@{$text_noreplies}, $tweet->{'text'});
    }
    push(@{$jdata}, $tweet);
    push(@{$text_all}, $tweet->{'text'});
  }
}

# Write arrayref back to a single JSON file.
# Use pretty printing to make it human-readable.
open OUT, '>', 'alltweets.json';
print OUT to_json($jdata, { pretty => 1, utf8 => 1 });
close OUT;

open OUT, '>', 'text-all.json';
print OUT to_json($text_all, { pretty => 1, utf8 => 1 });
close OUT;

open OUT, '>', 'text-replies.json';
print OUT to_json($text_replies, { pretty => 1, utf8 => 1 });
close OUT;

open OUT, '>', 'text-noreplies.json';
print OUT to_json($text_noreplies, { pretty => 1, utf8 => 1 });
close OUT;


# Display stats.
my $rpct = sprintf("%0.2f%%", $replies / $tweets * 100);
my $duration = time() - $tfrom;
print "$counter files processed in $duration seconds.\n";
print "Tweets: $tweets; replies: $replies; replies as \%age of tweets: $rpct\n";

