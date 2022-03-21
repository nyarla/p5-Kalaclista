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
  ro  => [qw( source outdir label href )],
  rw  => [qw( image width height )],
);

sub resize {
  my $self  = shift;
  my $image = Image::Scale->new( $self->source->stringify );

  $self->image($image);
  $self->width( $image->width );
  $self->height( $image->height );

  $self->outdir->mkpath;
  my $fn = $self->source->basename;
  $fn =~ s{\.[^\.]+$}{};

  $self->_resize( $self->outdir->child("${fn}_1x.png"), $X1RESIZE );
  $self->_resize( $self->outdir->child("${fn}_2x.png"), $X2RESIZE );

  if ( $self->width > $X1RESIZE ) {
    my $c  = $self->width / $X1RESIZE;
    my $rw = int( $self->width / $c );
    my $rh = int( $self->height / $c );

    $self->width($rw);
    $self->height($rh);
  }

  return $self;
}

sub _resize {
  my ( $self, $out, $resize ) = @_;

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

    $out->spew_raw( $resized->as_png );

    return $resized;
  }

  return undef;
}

sub as_html5 {
  my $self = shift;

  $self->resize;

  my $w = $self->width;
  my $h = $self->height;

  my $href_1x = $self->href;
  $href_1x =~ s{\.[^\.]+$}{_1x.png};

  my $href_2x = $self->href;
  $href_2x =~ s{\.[^\.]+$}{_2x.png};

  return <<"...";
<p class="img">
  <a href="" title="@{[ $self->label ]}">
    <img  alt="@{[ $self->label ]}"
          src="@{[ $self->href ]}"
          srcset="${href_1x} 1x, ${href_2x} 2x"
          width="${w}"
          height="${h}" />
  </a>
</p>
...
}

1;
