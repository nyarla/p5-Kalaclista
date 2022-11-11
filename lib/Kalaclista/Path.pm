package Kalaclista::Path;

use strict;
use warnings;
use utf8;

use feature qw(state);

use FindBin ();
use File::Spec;

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
      mkdir($path) or die "failed to mkdir: ${path}: ${!}";
    }
  }

  return $self;
}

sub tempdir {
  my ( $class, $format ) = @_;

  $format //= 'kalaclista_XXXXXXXXXX';

  state $chars  ||= [ split q{}, 'abdcefghijklmnopqrstuvwxyzABDCEFGHIJKLMNOPQRSTUVWXYZ._' ];
  state $len    ||= scalar( $chars->@* );
  state $tmpdir ||= $class->new( path => ( $ENV{'TMP'} // $ENV{'TEMP'} // $ENV{'TEMPDIR'} ), temporary => 0 );

  while (1) {
    my $path = $format;
    $path =~ s{X}{$chars->[rand($len-1)]}eg;

    my $dir = $tmpdir->child($path);
    if ( !-e $dir->path ) {
      $dir->temporary(1);
      $dir->mkpath;
      return $dir;
    }
  }
}

sub tempfile {
  my ( $class, $format ) = @_;

  $format //= 'kalaclista_XXXXXXXXXX';

  state $chars  ||= [ split q{}, 'abdcefghijklmnopqrstuvwxyzABDCEFGHIJKLMNOPQRSTUVWXYZ._' ];
  state $len    ||= scalar( $chars->@* );
  state $tmpdir ||= $class->new( path => ( $ENV{'TMP'} // $ENV{'TEMP'} // $ENV{'TEMPDIR'} ), temporary => 0 );

  while (1) {
    my $path = $format;
    $path =~ s{X}{$chars->[rand($len-1)]}eg;
    my $file = $tmpdir->child($path);

    if ( !-e $file->path ) {
      $file->temporary(1);
      $file->parent->mkpath;
      return $file;
    }
  }
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
