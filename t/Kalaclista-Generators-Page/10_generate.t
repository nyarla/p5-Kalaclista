#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Path;
use Kalaclista::Generators::Page;
use Kalaclista::Data::Page;

sub main {
  my $file = Kalaclista::Path->tempfile;
  my $page = Kalaclista::Data::Page->new;

  Kalaclista::Generators::Page->generate(
    dist     => $file,
    template => 'Test::Kalaclista::Templates::Test',
    page     => $page,
  );

  is( $file->load, 'ok' );

  done_testing;
}

main;

1;
