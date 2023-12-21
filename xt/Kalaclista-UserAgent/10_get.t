#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::UserAgent;

my $href = 'https://the.kalaclista.com';

subtest $href => sub {
  my $agent = Kalaclista::UserAgent->new(
    name    => 'Kalaclista::UserAgent',
    version => '0.01',
    contact => 'https://github.com/nyarla/p5-Kalaclista',
  );

  my $res = $agent->get($href);

  is $res->status, 200;
  is $res->reason, '';
  ok $res->success;

  is ref $res->headers, 'HASH';

  isa_ok $res->as_html, 'HTML5::DOM::Tree';
  like $res->as_html->at('title')->innerHTML, 'カラクリスタ';

};

done_testing;
