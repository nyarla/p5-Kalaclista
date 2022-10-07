#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI::Fast;

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

  baseURI => URI::Fast->new('https://example.com'),
  threads => 3,
);

sub main {
  my $context = Kalaclista::Context->instance;

  isa_ok( $context, 'Kalaclista::Context' );

  is( $context->section('test')->{'msg'}, 'hello' );

  $context->call( 'test', qw(ok ok) );

  is( [ $context->query( 'test', 'bar' ) ], [qw(foo bar)] );

  done_testing;
}

main;
