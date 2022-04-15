#!/usr/bin/env perl

use strict;
use warnings;

use Kalaclista::Directory;
use Kalaclista::Parallel::Files;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $testdir = $dirs->rootdir->child('t');

  my $runner = Kalaclista::Parallel::Files->new;

  $runner->run( $testdir->stringify, '**', '*.t' );

  print "1..1", "\n";
  print "ok 1", "\n";
}

main;
