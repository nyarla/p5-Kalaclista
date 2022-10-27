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
  rw  => [qw( root tmp )],
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
  my $dir  = $self->rootdir->child( $self->dist // 'dist' );

  $dir->mkpath if ( !$dir->is_dir );
  return $dir->realpath;
}

sub datadir {
  my $self = shift;
  my $dir  = $self->rootdir->child( $self->data // 'data' );

  $dir->mkpath if ( !$dir->is_dir );
  return $dir->realpath;
}

sub content_dir {
  my $self = shift;
  my $dir  = $self->rootdir->child( $self->content // 'content' );

  $dir->mkpath if ( !$dir->is_dir );
  return $dir->realpath;
}

sub templates_dir {
  my $self = shift;
  my $dir  = $self->rootdir->child( $self->templates // 'templates' );

  $dir->mkpath if ( !$dir->is_dir );
  return $dir->realpath;
}

sub assets_dir {
  my $self = shift;
  my $dir  = $self->rootdir->child( $self->assets // 'assets' );

  $dir->mkpath if ( !$dir->is_dir );
  return $dir->realpath;
}

sub build_dir {
  my $self = shift;

  if ( defined $self->tmp ) {
    return $self->tmp;
  }

  my $build = $self->build;

  my $dir =
      defined $build
      ? $self->rootdir->child($build)
      : tempdir( 'kalaclista_XXXXXX', CLEANUP => 1 );

  $dir->mkpath if ( !$dir->is_dir );
  $dir->realpath;

  $self->tmp($dir);

  return $self->tmp;
}

1;
