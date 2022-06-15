#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempdir);

use Kalaclista::Application;
use Kalaclista::Directory;

my $dirs = Kalaclista::Directory->instance;

sub config {
  my $config = $dirs->rootdir->child('t/fixtures/config.pl')->stringify;
  my $tmp    = tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 );
  $dirs->root($tmp);

  return $config;
}

sub main {
  my $config = config;

  my @argv = (
    '--config'  => $config,
    '--url'     => 'https://example.com',
    '--threads' => 3,
    '--action'  => 'running-test',
  );

  my $app = Kalaclista::Application->new;
  $app->run(@argv);

  done_testing;
}

main;
