#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI;

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Entry::Meta;

Kalaclista::Context->instance(
  dirs => Kalaclista::Directory->instance,
  data => {
    test => { msg => 'hello' },
  },
  call => {
    test => sub {
      my ( $val, $ok ) = @_;
      is( $val, $ok );
    },
  },
  query => {
    test => sub {
      my @args = @_;
      return ( qw{foo}, @args );
    },
  },

  baseURI => URI->new('https://example.com'),
  threads => 3,
);

sub main {
  my $config = Kalaclista::Context->instance;

  isa_ok( $config, 'Kalaclista::Context' );

  is( $config->section('test')->{'msg'}, 'hello' );

  $config->call( 'test', qw(ok ok) );

  is( [ $config->query( 'test', 'bar' ) ], [qw(foo bar)] );

  done_testing;
}

main;
