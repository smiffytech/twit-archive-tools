Twitter Archive Tools
=====================

Quick'n'dirty of Perl scripts to work with Twitter user archives.

* masher.pl - create a single JSON document from monthly archives.
* wc.pl - parse output of masher.pl to create word count JSON document.
* counter.pl - report on data created by wc.pl 

Please refer to comments in specific Perl files for further details.


Dependencies
------------

The following CPAN modules need to be installed:

* JSON (JSON::XS recommended)
* Data::Dumper
