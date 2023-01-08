#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Template qw(load);
use Kalaclista::Variables;

sub main {
  my $tmpl = load('Test::Kalaclista::TestTemplate');

  is( $tmpl->( Kalaclista::Variables->new ), 'ok' );

  done_testing;
}

main;
