#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

ok(
  try_ok {
    use Kalaclista::Entries;
  },
  "This module should be loadable"
);

done_testing;
