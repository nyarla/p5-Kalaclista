#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

ok(
  try_ok(
    sub {
      use Kalaclista::Data::Page;
    }
  ),
  'This module should be loadable',
);

done_testing;
