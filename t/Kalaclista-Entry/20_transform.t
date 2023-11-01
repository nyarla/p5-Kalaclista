#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Entry;

subtest transformer => sub {
  my $entry = Kalaclista::Entry->new;
  $entry->add_transformer(
    sub {
      my $item = shift;
      isa_ok $item, 'Kalaclista::Entry';
    }
  );

  $entry->transform;
};

done_testing;
