#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI;

use Kalaclista::Config;
use Kalaclista::Directory;
use Kalaclista::Entry::Meta;

Kalaclista::Config->instance(
  dirs => Kalaclista::Directory->instance,
  data => {
    test => { msg => 'hello' },
  },
  hooks => [
    [ 'Kalaclista::Entry::Meta', 'postprocess' ] => sub {
      my ( $meta, @args ) = @_;

      isa_ok( $meta, 'Kalaclista::Entry::Meta' );
      is( \@args, [ 1, 2, 3 ] );
    },
  ],
  baseURI => URI->new('https://example.com'),
  threads => 3,
);

sub main {
  my $config = Kalaclista::Config->instance;

  isa_ok( $config, 'Kalaclista::Config' );

  is( $config->section('test')->{'msg'}, 'hello' );

  $config->call( Kalaclista::Entry::Meta->new, 1, 2, 3 );

  done_testing;
}

main;
