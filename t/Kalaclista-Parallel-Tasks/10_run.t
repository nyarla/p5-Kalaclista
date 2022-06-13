#!/usr/bin/env perl

use strict;
use warnings;

use Kalaclista::Parallel::Tasks;

sub main {
  my $runner = Kalaclista::Parallel::Tasks->new;
  $runner->run;

  print "1..1", "\n";
  print "ok 1", "\n";
}

main;
