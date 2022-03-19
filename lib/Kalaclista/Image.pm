package Kalaclista::Image;

use strict;
use warnings;

our $X1RESIZE = "720";
our $X2RESIZE = "1440";

use Path::Tiny;

use URI;
use Image::Scale;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( source )],
  rw  => [qw( image width height x1 x2 )],
);

sub resize {
  my $self  = shift;
  my $dst   = shift;
  my $image = Image::Scale->new( $self->source->stringify );

  $self->image($image);
  $self->width( $image->width );
  $self->height( $image->height );

  $dst->mkpath;
  my $fn = $self->source->basename;
  $fn =~ s{\.[^\.]+$}{};

  $self->x1( $self->_resize( $dst->child("${fn}_1x.png"), $X1RESIZE ) );
  $self->x2( $self->_resize( $dst->child("${fn}_2x.png"), $X2RESIZE ) );

  return $self;
}

sub _resize {
  my ( $self, $dst, $resize ) = @_;

  if ( $self->width > $resize ) {
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

    $dst->spew_raw( $resized->as_png );

    return $resized;
  }

  return undef;
}

1;
