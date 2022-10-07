package Kalaclista::Actions::ResizeImages;

use strict;
use warnings;
use utf8;

use Kalaclista::Files;
use Kalaclista::Parallel::Files;

use File::Spec;
use Image::Scale;
use Path::Tiny;
use YAML::XS;

# TODO
my $x1 = 700;
my $x2 = 1400;

sub is_resized {
  my $fn = shift;
  return $fn =~ m{_thumb_\dx\.png$};
}

sub is_supported {
  my $fn = shift;
  return $fn !~ m{\.gif$};
}

sub basedir {
  my ( $path, $prefix ) = @_;

  utf8::decode($path);
  utf8::decode($prefix);

  $path =~ s{$prefix}{};
  $path =~ s{/([^/]+)$}{};

  return $path;
}

sub resize {
  my ( $dist, $image, $width ) = @_;

  my $c  = $image->width / $width;
  my $rw = int( $image->width / $c );
  my $rh = int( $image->height / $c );

  $image->resize_gm(
    {
      width  => $rw,
      height => $rh,
      filter => 'Triangle',
    }
  );

  $dist->parent->mkpath;
  $dist->spew_raw( $image->as_png );

  return {
    width  => $rw,
    height => $rh,
  };
}

sub makeHandle {
  my ( $assets, $build, $dist ) = @_;
  return sub {
    my $file = shift;

    if ( is_resized( $file->stringify ) ) {
      return {};
    }

    if ( !is_supported( $file->stringify ) ) {
      return {};
    }

    my $base = basedir( $file->stringify, $assets->stringify );

    my $fn    = $file->basename(qr<\.[^.]+$>);
    my $image = Image::Scale->new( $file->stringify );

    my $data = {
      origin => {
        width  => $image->width,
        height => $image->height,
      },
    };

    if ( $image->width <= $x1 ) {
      goto YAML;
    }

    if ( $image->width > $x1 ) {
      $data->{'1x'} = resize(
        $dist->child("${base}/${fn}_thumb_1x.png"),
        Image::Scale->new( $file->stringify ), $x1
      );
    }

    if ( $image->width > $x2 ) {
      $data->{'2x'} = resize(
        $dist->child("${base}/${fn}_thumb_2x.png"),
        Image::Scale->new( $file->stringify ), $x2
      );
    }

YAML:

    my $yaml = $build->child("${base}/${fn}.yaml");
    $yaml->parent->mkpath;
    $yaml->spew_utf8( YAML::XS::Dump($data) );

    return {};
  };
}

sub files {
  my ( $self, $rootdir ) = @_;

  $rootdir = File::Spec->join( $rootdir, 'images' );
  my @files = map { path($_) } Kalaclista::Files->find($rootdir);

  return @files;
}

sub action {
  my $class   = shift;
  my $context = shift;

  my $assets = $context->dirs->assets_dir;
  my $build  = $context->dirs->datadir;
  my $dist   = $context->dirs->distdir;

  my $runner = Kalaclista::Parallel::Files->new(
    handle => makeHandle( $assets, $build, $dist ),
    result => sub {
      my $result = shift;
      if ( exists $result->{'ERROR'} ) {
        print STDERR $result->{'ERROR'};
      }

      return $result;
    },
    threads => $context->threads,
  );

  return $runner->run( $class->files( $assets->stringify ) );
}

1;
