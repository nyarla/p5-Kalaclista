package Kalaclista::Path;

use strict;
use warnings;
use utf8;

use feature qw(state);

use FindBin ();
use File::Spec;
use File::Temp ();

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( path )],
  rw  => [qw( temporary )],
);

sub detect {
  my ( $class, $anchors ) = @_;

  my @dirs = File::Spec->splitdir($FindBin::Bin);
  while ( defined( my $dir = pop @dirs ) ) {
    if ( $dir =~ $anchors ) {
      return $class->new( path => File::Spec->join(@dirs) );
    }
  }

  die "failed to find parent directory of anchors";
}

sub parent {
  my $self = shift;
  my @path = File::Spec->splitdir( $self->path );
  pop @path;

  return ref($self)->new( path => File::Spec->join(@path) );
}

sub child {
  my ( $self, $path ) = @_;
  return ref($self)->new( path => File::Spec->join( $self->path, $path ) );
}

sub emit {
  my ( $self, $content ) = @_;

  utf8::encode($content) if ( utf8::is_utf8($content) );

  open( my $fh, '>', $self->path )
      or die "failed to open file: @{[ $self->path ]}: $!";

  print $fh $content;

  close($fh) or die "failed to close file: @{[ $self->path ]}: $!";

  return 1;
}

sub get {
  my $self = shift;

  open( my $fh, '<', $self->path )
      or die "failed to open file: @{[ $self->path ]}: $!";

  my $content = do { local $/; <$fh> };

  close($fh)
      or die "failed to close file: @{[ $self->path ]}: $!";

  return $content;
}

sub remove {
  my $self = shift;

  return if ( !-d $self->path && -e $self->path && unlink $self->path );
  return if ( -d $self->path && rmdir $self->path );
  return;
}

sub mkpath {
  my $self = shift;
  my @path = File::Spec->splitdir( File::Spec->rel2abs( $self->path ) );

  my $path = q{};
  while ( defined( my $dirname = shift @path ) ) {
    $path = File::Spec->join( $path, $dirname );

    if ( !-d $path ) {
      mkdir($path) or warn "failed to mkdir: ${path}: ${!}";
    }
  }

  return $self;
}

sub tempdir {
  my ( $class, $format ) = @_;
  $format //= 'kalaclista_XXXXXXXXXX';

  return $class->new( path => File::Temp::tempdir(), temporary => 1, );
}

sub tempfile {
  my ( $class, $format ) = @_;
  $format //= 'kalaclista_XXXXXXXXXX';

  return $class->new( path => ( File::Temp::tempfile() )[1], temporary => 1 );
}

sub cleanup {
  my $path = shift;

  do {
    if ( $path->temporary ) {
      if ( !-d $path->path && -e $path->path ) {
        $path->remove;
      }
      elsif ( -d $path->path && opendir( my $dh, $path->path ) ) {

        for my $fn ( readdir $dh ) {
          next if ( $fn eq q{.} || $fn eq q{..} );
          my $item = $path->child($fn);

          if ( -d $item->path ) {
            $item->temporary(1);
            $item->cleanup;
          }
          elsif ( !-d $item->path ) {
            $item->remove;
          }
        }

        closedir($dh) or die "failed to close dir:@{[ $path->path ]}: $!";

        $path->remove;
      }
    }
    return;
  } while ( defined( $path = $path->parent ) );
}

sub DESTROY {
  my $self = shift;
  $self->cleanup if ( $self->temporary );
}

1;
