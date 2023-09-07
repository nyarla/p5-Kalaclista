#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Data::WebSite;

subtest 'it should return true' => sub {
  my $web = Kalaclista::Data::WebSite->new( gone => 1 );

  ok $web->gone;
};

subtest 'it should return false' => sub {
  my $web = Kalaclista::Data::WebSite->new( gone => 0 );

  ok !$web->gone;
};

subtest 'default value is false' => sub {
  my $web = Kalaclista::Data::WebSite->new;

  ok !$web->gone;
};

done_testing;
