#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempdir);
use URI;

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Actions::GeneratePermalink;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $file = $dirs->rootdir->child('t/fixtures/build/test.md');
  $dirs->root( tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ) );

  my $context = Kalaclista::Context->instance(
    dirs => $dirs,
    data => {},
    call => {
      fixup => sub {
        if ( @_ == 1 ) {
          isa_ok( shift, 'Kalaclista::Entry::Meta' );
        }
        elsif ( @_ == 2 ) {
          isa_ok( shift, 'Kalaclista::Entry::Content' );
          isa_ok( shift, 'Kalaclista::Entry::Meta' );
        }
      },
    },
    query => {
      page => sub {
        isa_ok( shift, 'Kalaclista::Entry::Content' );
        isa_ok( shift, 'Kalaclista::Entry::Meta' );

        return 'ok';
      },
    },
    baseURI => URI->new('https://example.com'),
    threads => 1,
  );

  my $result =
    Kalaclista::Actions::GeneratePermalink::makeHandle($context)->($file);

  is( $result, 'ok' );

  done_testing;
}

main;
