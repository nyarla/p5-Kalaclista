#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Entry::Content;
use Kalaclista::Directory;

my $dirs = Kalaclista::Directory->instance;

sub transform {
  my $dom = shift;

  my $new = $dom->tree->createElement('p');
  $new->textContent("hello, again");

  $dom->at('p')->replace($new);

  return 1;
}

sub main {
  my $content = Kalaclista::Entry::Content->load( src => $dirs->rootdir->child('t/fixtures/content/test.md') );

  $content->transform( \&transform );

  is( $content->dom->at('p')->textContent, 'hello, again' );

  done_testing;
}

main;
