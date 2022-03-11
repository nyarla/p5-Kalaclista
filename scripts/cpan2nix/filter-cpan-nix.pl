#!/usr/bin/env perl

use strict;
use warnings;

sub filter {
  my $path = shift;
  open( my $fh, '<', $path )
    or die "failed to open file: $!";

  my $data = do { local $/; <$fh> };
  my $name = ( $data =~ m{([^ ]+) = buildPerlPackage} )[0];

  close($fh)
    or die "failed to close filehandle: $!";

  my $fn = ( $path =~ m{([^/]+)\.nix\.txt} )[0];

  if ( $name ne $fn && -e "data/cpan2nix/${name}.nix.txt" ) {
    return q{};
  }

  return $data;
}

sub main {
  for my $line (<STDIN>) {
    chomp($line);
    print filter($line), "\n";
  }

  exit 0;
}

main(@ARGV);
