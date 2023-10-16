#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

ok(
  try_ok(
    sub {
      use Kalaclista::Data::Directory;
    }
  ),
  'Kalaclista::Data::Directory is loadable'
);

done_testing;
