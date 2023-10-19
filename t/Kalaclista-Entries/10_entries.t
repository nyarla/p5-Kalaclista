#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Context;
use Kalaclista::Entries;

subtest instance => sub {
  my $c = Kalaclista::Context->init(
    production => 0,
    baseURI    => 'https://example.com',
    dirs       => { detect => qr{^t$} },
  );

  my $entries = Kalaclista::Entries->instance( $c->dirs->rootdir->child('fixtures/content')->path );
  my $entry   = $entries->entries->[0];

  $entries->fixup(
    sub {
      isa_ok( (shift), 'Kalaclista::Entry' );
    }
  );

  is( $entry->href->to_string, 'https://example.com/test/' );
};

done_testing;
