#!/usr/bin/env perl

use strict;
use warnings;

sub filename {
  my $module = shift;
  $module =~ s{::}{}g;

  return "${module}.nix.txt";
}

sub modname {
  my $module = shift;
  $module =~ s{::}{}g;

  return "perlPackages.${module}";
}

sub find {
  my $modname = shift;
  $modname =~ s{::}{};
  return (
    grep  { $_ =~ m{perlPackages\.$modname \(} }
      map { $_ =~ s{\e\[[0-9;]*m(?:\e\[K)?}{}g; $_ }
      `nix search nixpkgs perlPackages.${modname}`
  ) > 0;
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
    exit 0 if ( find($module) );
    `nix-generate-from-cpan ${module} > ${path}`;
  }

  exit 0;
}

main(@ARGV);
