#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Entry;
use Kalaclista::Path;

subtest href => sub {
  subtest 'instantiate with URI::Fast' => sub {
    my $entry = Kalaclista::Entry->new( href => URI::Fast->new('https://example.com') );
    isa_ok $entry->href, 'URI::Fast';
    is $entry->href->to_string, 'https://example.com';
  };

  subtest 'instantiate with URI string' => sub {
    my $entry = Kalaclista::Entry->new( href => 'https://example.com' );
    isa_ok $entry->href, 'URI::Fast';
    is $entry->href->to_string, 'https://example.com';
  };

  subtest 'instantiate with emptry stirng' => sub {
    my $entry = Kalaclista::Entry->new( href => q{} );
    is $entry->href, undef;
  };

  subtest 'instantiate without argument' => sub {
    my $entry = Kalaclista::Entry->new();
    is $entry->href, undef;
  };

  subtest 'set $href by URI::Fast' => sub {
    my $entry = Kalaclista::Entry->new;
    $entry->href( URI::Fast->new('https://example.com') );
    is $entry->href->to_string, 'https://example.com';
  };

  subtest 'set $href by string' => sub {
    my $entry = Kalaclista::Entry->new;
    $entry->href('https://example.com');
    is $entry->href->to_string, 'https://example.com';
  };

  subtest 'write empty string failed' => sub {
    my $entry = Kalaclista::Entry->new;
    ok(
      dies(
        sub {
          $entry->href(q{});
        }
      )
    );
  };

  subtest 'write undef value failed' => sub {
    my $entry = Kalaclista::Entry->new;
    ok(
      dies(
        sub {
          $entry->href(undef);
        }
      )
    );
  };
};

done_testing;
