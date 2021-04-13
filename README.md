Twitter Archive Tools
=====================

To read tweet.js or tweet-part1.js (or more, if you've got over
200Mb of tweets), you must first strip the leading characters on 
the first line, so that the first character is an open square
bracket [, otherwise the file is not valid JSON. (It's a JavaScript
variable assignment).

parse-tweets.pl FILENAME

Reads the tweet.js or tweet-part1.js from a Twitter archive, 
extracts ID, timestamp, tweet content to CSV.

Uncomment the line starting "print Dumper" to dump off the first
tweet so you can see the record structure.


Old Code - Probably Doesn't Work Anymore
----------------------------------------

These are 7 years oldi (April 2021), format has most likely changed.

* masher.pl - create a single JSON document from monthly archives.
* wc.pl - parse output of masher.pl to create word count JSON document.
* counter.pl - report on data created by wc.pl 

Please refer to comments in specific Perl files for further details.


Dependencies
------------

The following CPAN modules need to be installed:

* File::Slurp
* JSON (JSON::XS recommended)
* Data::Dumper
