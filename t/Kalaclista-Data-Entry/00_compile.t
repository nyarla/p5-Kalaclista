#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

subtest use => sub {
  my $success = lives {
    use Kalaclista::Data::Entry;
  };

  ok $success;
};

done_testing;
