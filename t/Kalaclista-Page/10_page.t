#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempdir);
use URI;

use Kalaclista::Page;
use Kalaclista::Directory;

sub main {
  my $dirs = Kalaclista::Directory->instance;
  my $tmpl = $dirs->rootdir->child('t/fixtures/templates/page.pl')->stringify;

  $dirs->root( tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ) );

  my $page = Kalaclista::Page->new(
    dist     => $dirs->build_dir->child('test.out'),
    baseURI  => URI->new('https://example.com/foo/bar'),
    template => $tmpl,
    vars     => {
      foo => 'bar',
    },
  );

  $page->emit;

  is( $dirs->build_dir->child('test.out')->slurp, q{hello, world!} );

  done_testing;
}

main;
