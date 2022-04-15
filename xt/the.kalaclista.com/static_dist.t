#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Directory;

my $dirs =
  Kalaclista::Directory->instance( dist => 'dist/the.kalaclista.com', );

sub main {
  my @tests = qw(
    assets/avatar.png
    assets/avatar.svg
    ads.txt
    apple-touch-icon.png
    favicon.ico
    icon-192.png
    icon-512.png
    icon.svg
    manifest.webmanifest
    robots.txt
  );

  for my $fn (@tests) {
    my $file = $dirs->distdir->child($fn);
    ok( $file->is_file, "File does not exsits: " . $file->stringify );
  }

  done_testing;
}

main;
