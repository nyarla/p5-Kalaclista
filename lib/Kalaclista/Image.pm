package Kalaclista::Image;

use strict;
use warnings;

our $Resize1x = "720";
our $Resize2x = "1440";

use Image::Scale;
use Path::Tiny;
use URI;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( source outdir label href )],
);

use Kalaclista::HyperScript qw(p a img);

sub width {
  my $self = shift;

  if ( exists $self->{'width'} && $self->{'width'} > 0 ) {
    return $self->{'width'};
  }

  my $width = $self->image->width;
  if ( $width > $Resize1x ) {
    my $rw = int( $width / ( $width / $Resize1x ) );
    $width = $rw;
  }

  $self->{'width'} = $width;

  return $width;
}

sub height {
  my $self = shift;

  if ( exists $self->{'height'} && $self->{'height'} > 0 ) {
    return $self->{'height'};
  }

  my $height = $self->image->height;
  if ( $self->image->width > $Resize1x ) {
    my $rh = int( $height / ( $self->image->width / $Resize1x ) );
    $height = $rh;
  }

  $self->{'height'} = $height;

  return $height;
}

sub image {
  my $self = shift;

  if ( exists $self->{'image'} && ref $self->{'image'} eq 'Image::Scale' ) {
    return $self->{'image'};
  }

  my $image = Image::Scale->new( $self->source->stringify );
  $self->{'image'} = $image;

  return $image;
}

sub to_html {
  my $self = shift;

  my $w = $self->width;
  my $h = $self->height;

  my $href_1x = $self->href;
  $href_1x =~ s{\.[^\.]+$}{_1x.png};

  my $href_2x = $self->href;
  $href_2x =~ s{\.[^\.]+$}{_2x.png};

  return p(
    { class => 'img' },
    a(
      {
        href  => $self->href,
        title => $self->label,
      },
      img(
        {
          alt    => $self->label,
          src    => $self->href,
          srcset => "${href_1x} 1x, ${href_2x} 2x",
          width  => $w,
          height => $h,
        }
      )
    )
  );
}

sub resize {
  my $self  = shift;
  my $image = $self->image;

  my $fn = $self->source->basename;
  $fn =~ s{\.[^\.]+$}{};

  $self->_resize( $self->outdir->child("${fn}_1x.png"), $Resize1x );
  $self->_resize( $self->outdir->child("${fn}_2x.png"), $Resize2x );
}

sub _resize {
  my ( $self, $out, $resize ) = @_;

  if ( $self->image->width > $resize ) {
    my $c  = $self->width / $resize;
    my $rw = int( $self->width / $c );
    my $rh = int( $self->height / $c );

    my $resized = Image::Scale->new( $self->source );
    $resized->resize_gm(
      {
        width  => $rw,
        height => $rh,
        filter => 'Triangle',
      }
    );

    $out->spew_raw( $resized->as_png );

    return $resized;
  }

  return undef;
}

1;
