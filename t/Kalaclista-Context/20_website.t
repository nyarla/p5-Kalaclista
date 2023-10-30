#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Context;

my $c = Kalaclista::Context->init(
  baseURI => 'https://example.com',
  dirs    => {
    detect => qr{^t$},
  },
  production => !!0,
);

subtest website => sub {
  $c->website( label => 'test' );

  is $c->website->label, 'test';
};

subtest sections => sub {
  $c->sections( test => { label => 'test2' } );

  is $c->sections->{'test'}->label, 'test2';
};

done_testing;
