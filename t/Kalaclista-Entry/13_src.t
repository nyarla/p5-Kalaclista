#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Entry;
use Kalaclista::Path;

use HTML5::DOM;

my $fixtures = Kalaclista::Path->detect(qr{^t$})->child('fixtures');
my $parser   = HTML5::DOM->new( { script => 1 } );

subtest src => sub {
  my $entry = Kalaclista::Entry->new( path => $fixtures->child('content/test.md') );

  $entry->load if !$entry->loaded;
  is $entry->src, "\nhello, world!\n";

  $entry->src("test");
  is $entry->src, "test";
};

subtest dom => sub {
  my $entry = Kalaclista::Entry->new( path => $fixtures->child('content/test.md') );
  $entry->src(q{<p>hello, world!</p>});

  like ref( $entry->dom ), qr{^HTML5::DOM};
  is $entry->dom->at('*:first-child')->textContent, "hello, world!";

  $entry->dom( $parser->parse('<p>hi,</p>')->body );
  is $entry->dom->at('*:first-child')->textContent, "hi,";
};

done_testing;
