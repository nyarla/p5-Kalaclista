#!/usr/bin/env perl

use v5.38;
use builtin qw(true false);
no warnings qw(experimental);

use Kalaclista::Context;

use Test2::V0;

subtest environment => sub {
  no warnings qw(experimental);
  subtest production => sub {
    my $env = Kalaclista::Context::Environment->new(
      environment => 'production',
      on          => 'local',
    );

    is $env->production,  true;
    is $env->development, false;
    is $env->staging,     false;
    is $env->test,        false;
  };

  subtest development => sub {
    my $env = Kalaclista::Context::Environment->new(
      environment => 'development',
      on          => 'local',
    );

    is $env->production,  false;
    is $env->development, true;
    is $env->staging,     false;
    is $env->test,        false;
  };

  subtest staging => sub {
    my $env = Kalaclista::Context::Environment->new(
      environment => 'staging',
      on          => 'local',
    );

    is $env->production,  false;
    is $env->development, false;
    is $env->staging,     true;
    is $env->test,        false;
  };

  subtest test => sub {
    my $env = Kalaclista::Context::Environment->new(
      environment => 'test',
      on          => 'local',
    );

    is $env->production,  false;
    is $env->development, false;
    is $env->staging,     false;
    is $env->test,        true;
  };
};

subtest on => sub {
  no warnings qw(experimental);

  subtest ci => sub {
    my $env = Kalaclista::Context::Environment->new(
      environment => 'test',
      on          => 'ci',
    );

    is $env->ci,      true;
    is $env->local,   false;
    is $env->runtime, false;
  };

  subtest local => sub {
    my $env = Kalaclista::Context::Environment->new(
      environment => 'test',
      on          => 'local',
    );

    is $env->ci,      false;
    is $env->local,   true;
    is $env->runtime, false;
  };

  subtest ci => sub {
    my $env = Kalaclista::Context::Environment->new(
      environment => 'test',
      on          => 'runtime',
    );

    is $env->ci,      false;
    is $env->local,   false;
    is $env->runtime, true;
  };
};

done_testing;
