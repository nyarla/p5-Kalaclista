#!/usr/bin/env perl

use v5.38;

use Test2::V0;

subtest use => sub {
  my $success = lives {
    eval { use Kalaclista::Loader::Content; };
    $@ if $@;
  };

  ok $success;
};

done_testing;
