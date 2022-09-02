#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI;
use Path::Tiny qw( tempdir );

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Actions::GenerateArchive;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $file = $dirs->rootdir->child('t/fixtures/build/test.yaml');
  $dirs->root( tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ) );

  my $context = Kalaclista::Context->new(
    dirs => $dirs,
    data => {},
    call => {
      fixup => sub {
        if ( @_ == 1 ) {
          my $meta = shift;
          $meta->title('hello, world!');
        }

        if ( @_ == 2 ) {
          isa_ok( $_[0], 'Kalaclista::Entry::Content' );
          isa_ok( $_[1], 'Kalaclista::Entry::Meta' );
        }
      },
    },
    query   => {},
    baseURI => URI->new('https://example.com'),
    threads => 1,
  );

  my $meta =
    Kalaclista::Actions::GenerateArchive::makeHandle($context)->($file);

  is( $meta->title, 'hello, world!' );

  done_testing;
}

main;
