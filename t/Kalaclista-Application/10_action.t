#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Application;
use Kalaclista::Directory;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my @argv = (
    '--config'  => $dirs->rootdir->child('t/fixtures/config.pl')->realpath,
    '--url'     => 'https://example.com',
    '--threads' => 3,
    '--action'  => 'running-test',
  );

  print $argv[1], "\n";

  my $app = Kalaclista::Application->new;
  $app->run(@argv);

  done_testing;
}

main;
