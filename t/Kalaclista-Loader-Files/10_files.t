#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Path;
use Kalaclista::Loader::Files;

subtest files => sub {
  my $root = Kalaclista::Path->detect(qr{^t$})->child('lib')->to_string;
  like $_, qr{\.pm$} for files $root;
};

done_testing;
