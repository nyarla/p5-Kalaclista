package Kalaclista::Directory;

use strict;
use warnings;

use FindBin;
use File::Spec;
use Path::Tiny qw(path tempdir);
use Carp qw( confess );

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( dist data assets content build templates )],
  rw  => [qw( root )],
);

my $instance;

sub instance {
  my $proto = shift;

  if ( defined $instance ) {
    return $instance;
  }

  $instance = $proto->new(@_);

  return $instance;
}

sub rootdir {
  my $self = shift;

  if ( ref( $self->root ) eq 'Path::Tiny' ) {
    return $self->root;
  }

  my $path = path($FindBin::Bin)->realpath;
  my @dirs = (
    qw( bin lib t xt ),
    ( $self->dist      // 'dist' ),
    ( $self->data      // 'data' ),
    ( $self->assets    // 'assets' ),
    ( $self->content   // 'content' ),
    ( $self->templates // 'templates' ),
  );

  do {
    for my $dir (@dirs) {
      if ( $path->child($dir)->is_dir ) {
        $self->root($path);
        return $self->root;
      }
    }
  } while ( defined( $path = $path->parent ) );

  confess "cannot find root directory.";
}

sub distdir {
  my $self = shift;
  return $self->rootdir->child( $self->dist // 'dist' )->realpath;
}

sub datadir {
  my $self = shift;
  return $self->rootdir->child( $self->data // 'data' )->realpath;
}

sub content_dir {
  my $self = shift;
  return $self->rootdir->child( $self->content // 'content' )->realpath;
}

sub templates_dir {
  my $self = shift;
  return $self->rootdir->child( $self->templates // 'templates' )->realpath;
}

sub assets_dir {
  my $self = shift;
  return $self->rootdir->child( $self->assets // 'assets' )->realpath;
}

sub build_dir {
  my $self = shift;
  my $dir  = $self->build;
  if ( defined $dir ) {
    return $self->rootdir->child($dir)->realpath;
  }
  return tempdir( 'kalaclista_XXXXXX', CLEANUP => 1 )->realpath;
}

1;
