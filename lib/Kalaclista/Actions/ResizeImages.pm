package Kalaclista::Actions::ResizeImages;

use strict;
use warnings;
use utf8;

use Kalaclista::Parallel::Files;
use Kalaclista::Utils qw(make_fn);
use Image::Scale;
use YAML::Tiny;

my $x1 = 720;
my $x2 = 1440;

sub action {
  my $class = shift;
  my $app   = shift;

  my $dir   = $app->config->dirs->assets_dir->realpath;
  my $build = $app->config->dirs->build_dir->realpath;
  my $out   = $app->config->dirs->distdir->realpath;

  my $runner = Kalaclista::Parallel::Files->new(
    handle => sub {
      my $file = shift;

      if ( $file->stringify =~ m{_thumb_\dx\.png$} ) {
        return {};
      }

      if ( $file->stringify =~ m{\.gif$} ) {
        return {};
      }

      my $path   = $file->stringify;
      my $prefix = $dir->stringify;

      $path =~ s{$prefix}{};
      utf8::decode($path);

      my $data = { origin => $path };

      my $image = Image::Scale->new( $file->stringify );
      my $fn    = $file->basename(qr<\.[^.]+$>);

      if ( $image->width <= $x1 ) {
        goto YAML;
      }

      if ( $image->width > $x1 ) {
        my $resized = $file->parent->child("${fn}_thumb_1x.png");
        resize( $resized, $image, $x1 );
        my $rp = $path;
        $rp =~ s{\.([^.]+)$}{_thumb_1x.png};
        $data->{'1x'} = $rp;
      }

      if ( $image->width > $x2 ) {
        my $resized = $file->parent->child("${fn}_thumb_2x.png");
        resize( $resized, $image, $x2 );
        my $rp = $path;
        $rp =~ s{\.([^.]+)$}{_thumb_2x.png};
        $data->{'2x'} = $rp;
      }

    YAML:

      my $yaml = YAML::Tiny::Dump($data);

      my $info = $build->child("${path}.yaml");
      $info->parent->mkpath;
      $info->spew($yaml);

      return {};
    },
    threads => $app->config->threads,
  );

  $runner->run( $dir->stringify, 'images', '**', '*.*' );
}

sub resize {
  my ( $out, $image, $size ) = @_;

  my $c  = $image->width / $size;
  my $rw = int( $image->width / $c );
  my $rh = int( $image->height / $c );

  $image->resize_gm(
    {
      width  => $rw,
      height => $rh,
      filter => 'Triangle',
    }
  );

  $out->spew_raw( $image->as_png );

  return 1;
}

1;
