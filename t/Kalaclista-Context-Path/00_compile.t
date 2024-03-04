#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

subtest failed => sub {
  my $failure = dies {
    eval 'use Kalaclista::Context::Path';
    die $@ if $@;
  };

  like $failure, qr|^missing regexp to detect rootdir; usage: 'use Kalaclista::Context::Path qr\{\^lib\$\}'|;
};

subtest ok => sub {
  my $success = lives {
    eval 'use Kalaclista::Context::Path qr{^t$}';
    die $@ if $@;
  };

  ok $success;
};

done_testing;
