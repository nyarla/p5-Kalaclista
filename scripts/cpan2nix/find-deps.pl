#!/usr/bin/env perl

use strict;
use warnings;

use Module::CoreList;

sub distname {
  my $module = shift;
  my $out    = `cpanm --info ${module}`;
  chomp($out);

  my $name = ( ( split q{/}, $out )[1] =~ m{((?:\w+-?)+)-} )[0];
  $name =~ s{-}{::}g;

  return $name;
}

sub main {
  my @modules = map { chomp($_); $_ } `cpanfile-dump`;
  my %found;

  while ( defined( my $module = shift @modules ) ) {
    next if ( $module eq 'perl' );
    if ( !exists $found{$module} ) {
      $found{$module} = distname($module);
    }

    print "search dependences: ${module}", "\n";
    for my $depend (`cpanm -q --showdeps $module`) {
      chomp($depend);
      $depend =~ s{~.+$}{};

      next if ( $depend eq 'perl' );

      if ( !exists $found{$depend} && !Module::CoreList::is_core($depend) ) {
        $found{$depend} = distname($depend);
        unshift @modules, $depend;
      }
    }
  }

  my @pkgs = do {
    my %t;
    grep { !$t{$_}++ } grep { defined($_) && $_ ne q{} } values %found;
  };

  if ( !-e "resources/_cpan2nix/modules.txt" ) {
    system(qw(mkdir -p resources/_cpan2nix));
  }

  open( my $fh, '>', 'resources/_cpan2nix/modules.txt' )
    or die "failed to open file: $!";
  print $fh ( join qq{\n}, sort @pkgs, '' );
  close($fh)
    or die "failed to close file handle: $!";
}

main;
