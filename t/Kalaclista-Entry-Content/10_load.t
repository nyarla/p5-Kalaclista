#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Entry::Content;
use Kalaclista::Directory;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $entry = Kalaclista::Entry::Content->load( src => $dirs->rootdir->child('t/fixtures/content/test.md') );

  is( $entry->dom->tag,                  'body' );
  is( $entry->dom->at('p')->textContent, "hello, world!" );

  done_testing;
}

main;
