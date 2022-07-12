#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Directory;
use Kalaclista::Sequential::Files;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $testdir = $dirs->rootdir->child('t');

  my $runner = Kalaclista::Sequential::Files->new(
    handle => sub {
      my $file = shift;

      like( $file->stringify, qr{\.t$} );

      return q{ok};
    },

    result => sub {
      for my $result (@_) {
        is( $result, 'ok' );
      }
    },
  );

  $runner->run( $testdir->stringify, 'Kalaclista-*', '**', '*.t' );

  done_testing;
}

main;
