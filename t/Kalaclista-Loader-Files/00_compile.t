#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

subtest use => sub {
  my $success = lives {
    eval { use Kalaclista::Loader::Files; };
    die $@ if $@;
  };

  ok $success;
};

done_testing;
