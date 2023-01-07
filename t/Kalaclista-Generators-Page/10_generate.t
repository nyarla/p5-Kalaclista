#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Path;
use Kalaclista::Generators::Page;
use Kalaclista::Variables;

sub main {
  my $file = Kalaclista::Path->tempfile;
  my $vars = Kalaclista::Variables->new;

  Kalaclista::Generators::Page->generate(
    dist     => $file,
    template => 'Test::Kalaclista::TestTemplate',
    vars     => $vars,
  );

  is( $file->get, 'ok' );

  done_testing;
}

main;

1;
