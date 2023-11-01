#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Entry;
use Kalaclista::Path;

my $fixtures = Kalaclista::Path->detect(qr{^t$})->child('fixtures');

subtest path => sub {
  subtest 'instantiate with string' => sub {
    my $entry = Kalaclista::Entry->new( path => $fixtures->child('content/test.md')->path );
    isa_ok $entry->path, "Kalaclista::Path";
    is $entry->path->path, $fixtures->child('content/test.md')->path;
  };

  subtest 'instantiate with Kalaclista::Path' => sub {
    my $entry = Kalaclista::Entry->new( path => $fixtures->child('content/test.md') );
    isa_ok $entry->path, 'Kalaclista::Path';
    is $entry->path->path, $fixtures->child('content/test.md')->path;
  };

  subtest 'instantiate with empty stirng' => sub {
    my $entry = Kalaclista::Entry->new( path => q{} );
    is $entry->path, undef;
  };

  subtest 'instantiate without argument' => sub {
    my $entry = Kalaclista::Entry->new;
    is $entry->path, undef;
  };

  subtest 'set $path by Kalaclista::Path' => sub {
    my $entry = Kalaclista::Entry->new;
    $entry->path( $fixtures->child('content/test.md') );
    is $entry->path->path, $fixtures->child('content/test.md')->path;
  };

  subtest 'set $path by string' => sub {
    my $entry = Kalaclista::Entry->new;
    $entry->path( $fixtures->child('content/test.md')->path );
    is $entry->path->path, $fixtures->child('content/test.md')->path;
  };

  subtest 'set $path by undef failed' => sub {
    my $entry = Kalaclista::Entry->new;
    ok(
      dies(
        sub {
          $entry->path(undef);
        }
      )
    );
  };

  subtest 'set $path by empty string failed' => sub {
    my $entry = Kalaclista::Entry->new;
    ok(
      dies(
        sub {
          $entry->path(q{});
        }
      )
    );
  };
};

done_testing;
