package Kalaclista::Directory;

use strict;
use warnings;

use FindBin;
use File::Spec;
use Path::Tiny;

my $rootdir;

BEGIN {
  my @path = File::Spec->splitdir($FindBin::Bin);
  while ( defined( my $dir = pop @path ) ) {
    if ( $dir eq q{t} || $dir eq q{xt} ) {
      $rootdir = path( join q{/}, @path );
      last;
    }
  }
}

sub rootdir {
  return $rootdir;
}

sub distdir {
  return $rootdir->child("dist");
}

1;
