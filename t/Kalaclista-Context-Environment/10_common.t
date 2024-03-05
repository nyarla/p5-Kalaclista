#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Context::Environment;

subtest stage => sub {
  subtest production => sub {
    my $env = Kalaclista::Context::Environment->new( stage => 'production', on => 'runtime' );

    ok $env->production;
    ok !$env->development;
    ok !$env->staging;
    ok !$env->test;
  };

  subtest development => sub {
    my $env = Kalaclista::Context::Environment->new( stage => 'development', on => 'runtime' );

    ok !$env->production;
    ok $env->development;
    ok !$env->staging;
    ok !$env->test;
  };

  subtest staging => sub {
    my $env = Kalaclista::Context::Environment->new( stage => 'staging', on => 'runtime' );

    ok !$env->production;
    ok !$env->development;
    ok $env->staging;
    ok !$env->test;
  };

  subtest test => sub {
    my $env = Kalaclista::Context::Environment->new( stage => 'test', on => 'runtime' );

    ok !$env->production;
    ok !$env->development;
    ok !$env->staging;
    ok $env->test;
  };
};

subtest on => sub {
  subtest runtime => sub {
    my $env = Kalaclista::Context::Environment->new( stage => 'test', on => 'runtime' );

    ok $env->runtime;
    ok !$env->local;
    ok !$env->ci;
  };

  subtest local => sub {
    my $env = Kalaclista::Context::Environment->new( stage => 'test', on => 'local' );

    ok !$env->runtime;
    ok $env->local;
    ok !$env->ci;
  };

  subtest ci => sub {
    my $env = Kalaclista::Context::Environment->new( stage => 'test', on => 'ci' );

    ok !$env->runtime;
    ok !$env->local;
    ok $env->ci;
  };
};

done_testing;
