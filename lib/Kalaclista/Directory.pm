package Kalaclista::Directory;

use strict;
use warnings;

use FindBin;
use File::Spec;
use Path::Tiny qw(path tempdir);

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( dist data assets content build )],
);

my $rootdir;
my $instance;

BEGIN {
  my @path = File::Spec->splitdir($FindBin::Bin);
  my @dirs = qw( t xt scripts lib bin );

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
  return $rootdir->child( (shift)->dist // 'dist' )->realpath;
}

sub datadir {
  return $rootdir->child( (shift)->data // 'data' )->realpath;
}

sub assets_dir {
  return $rootdir->child( (shift)->assets // 'assets' )->realpath;
}

sub content_dir {
  return $rootdir->child( (shift)->content // 'content' )->realpath;
}

sub build_dir {
  my $dir = shift->build;
  if ( defined $dir ) {
    return $rootdir->child($dir)->realpath;
  }
  return tempdir( 'kalaclista_XXXXXX', CLEANUP => 1 )->realpath;
}

1;
