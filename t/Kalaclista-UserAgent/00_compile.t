#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

my $done = lives {
  use Kalaclista::UserAgent;
};

ok $done;

done_testing;
