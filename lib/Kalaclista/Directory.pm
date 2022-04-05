package Kalaclista::Directory;

use strict;
use warnings;

use FindBin;
use File::Spec;
use Path::Tiny;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( dist data assets content )],
);

my $rootdir;
my $instance;

BEGIN {
  my @path = File::Spec->splitdir($FindBin::Bin);
  my @dirs = qw( t xt scripts lib );

  while ( defined( my $dir = pop @path ) ) {
    if ( grep { $_ eq $dir } @dirs ) {
      $rootdir = path( File::Spec->catdir(@path) )->realpath;
    }
  }
}

sub instance {
  my $proto = shift;

  if ( defined $instance ) {
    return $instance;
  }

  $instance = $proto->new(@_);

  return $instance;
}

sub rootdir {
  return $rootdir;
}

sub distdir {
  return $rootdir->child( (shift)->dist // 'dist' );
}

sub datadir {
  return $rootdir->child( (shift)->data // 'data' );
}

sub assets_dir {
  return $rootdir->child( (shift)->assets // 'assets' );
}

sub content_dir {
  return $rootdir->child( (shift)->content // 'content' );
}

1;
