#!/usr/bin/env perl

use strict;
use warnings;

sub filename {
  my $module = shift;
  $module =~ s{::}{}g;

  return "${module}.nix.txt";
}

sub main {
  my $module = shift;
  my $dir    = "data/cpan2nix";
  if ( !-d $dir ) {
    system( qw(mkdir -p ), $dir );
  }

  my $fn   = filename($module);
  my $path = "${dir}/${fn}";

  if ( !-e $path ) {
    `sh -c "nix-generate-from-cpan ${module} > ${path}"`;
  }

  exit 0;
}

main(@ARGV);
