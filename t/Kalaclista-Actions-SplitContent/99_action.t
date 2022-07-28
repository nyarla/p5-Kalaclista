#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI;

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Actions::SplitContent;

my $dirs = Kalaclista::Directory->instance( content => 't/fixtures/content' );

sub main {
  my $ctx = Kalaclista::Context->instance(
    dirs    => $dirs,
    data    => {},
    query   => {},
    call    => {},
    baseURI => URI->new('https://example.com'),
    threads => 1,
  );

  Kalaclista::Actions::SplitContent->action($ctx);

  my $dest = $dirs->build_dir->child('contents');

  is( $dest->child('test.yaml')->slurp, "title: hello\n" );
  is( $dest->child('test.md')->slurp,   "\nhello, world!\n" );

  done_testing;
}

main;
