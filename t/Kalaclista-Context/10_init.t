#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Context;

subtest init => sub {
  ok(
    try_ok {
      Kalaclista::Context->init(
        baseURI => 'http://example.com',
        dirs    => {
          detect => qr{^t$},
        },
        production => !!0,
      );
    },
    'This module shoule be initialisable'
  );
};

subtest instance => sub {
  isa_ok( Kalaclista::Context->instance, 'Kalaclista::Context' );
};

subtest baseURI => sub {
  isa_ok( Kalaclista::Context->instance->baseURI, 'URI::Fast' );
};

subtest dirs => sub {
  isa_ok( Kalaclista::Context->instance->dirs, 'Kalaclista::Data::Directory' );
};

subtest production => sub {
  ok( !Kalaclista::Context->instance->production, 'In this case, this method should return false' );
};

done_testing;
