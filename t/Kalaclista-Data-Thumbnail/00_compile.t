#!/usr/bin/env perl

use v5.38;
use utf8;

use Test2::V0;

subtest use => sub {
  my $success = lives {
    eval 'use Kalaclista::Data::Thumbnail;';
    die $@ if $@;
  };

  ok $success;
};

done_testing;
