#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Path;
use Kalaclista::Context::Path qr{^t$};

subtest rootdir => sub {
  my $test     = rootdir;
  my $expected = Kalaclista::Path->detect(qr{^t$});

  is $test->to_string, $expected->to_string;
};

done_testing;
