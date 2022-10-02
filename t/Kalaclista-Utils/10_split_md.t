#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Directory;
use Kalaclista::Utils qw( split_md );

my $data = Kalaclista::Directory->instance->rootdir->child('t/Kalaclista-Utils/fixture.md');

sub main {
  my ( $yaml, $md ) = split_md $data;

  is( $yaml, <<'...');
title: hello world!
...

  is( $md, <<'...');
content body
...

  done_testing;
}

main;
