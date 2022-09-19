#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Template qw(load);

sub main {
  my $tmpl = load('TestApp::Templates::Home');

  is( $tmpl->(), 'hello' );

  done_testing;
}

main;
