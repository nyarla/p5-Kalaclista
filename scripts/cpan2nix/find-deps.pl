#!/usr/bin/env perl

use strict;
use warnings;

use Module::CoreList;

sub main {
  my @modules = map { chomp($_); $_ } `cpanfile-dump`;
  my %found   = ();
  my @pkgs    = ();

  while ( defined( my $module = shift @modules ) ) {
    next if ( $module eq 'perl' );
    if ( !exists $found{$module} ) {
      $found{$module}++;
      unshift @pkgs, $module;
    }

    print "search dependences: ${module}", "\n";
    for my $depend (`cpanm -q --showdeps $module`) {
      chomp($depend);
      $depend =~ s{~.+$}{};

      if ( !exists $found{$depend} && !Module::CoreList::is_core($depend) ) {
        $found{$depend}++;
        unshift @pkgs,    $depend;
        unshift @modules, $depend;
      }
    }
  }

  if ( !-e "resources/_cpan2nix/modules.txt" ) {
    system(qw(mkdir -p resources/_cpan2nix));
  }

  open( my $fh, '>', 'resources/_cpan2nix/modules.txt' )
    or die "failed to open file: $!";
  print $fh ( join qq{\n}, @pkgs, '' );
  close($fh)
    or die "failed to close file handle: $!";
}

main;
