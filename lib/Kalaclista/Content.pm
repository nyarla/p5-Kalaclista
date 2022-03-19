package Kalaclista::Content;

use strict;
use warnings;
use utf8;

use CommonMark;
use HTML5::DOM;
use Path::Tiny;
use URI;

use Kalaclista::Image;

use Class::Accessor::Lite (
  new => 1,
  rw  => [qw( title type date lastmod src dst text )],
);

my $parser = HTML5::DOM->new(
  {
    script => 1,
  }
);

sub dom {
  my $self = shift;

  if ( @_ == 0 ) {
    if ( exists $self->{'dom'} && defined $self->{'dom'} ) {
      return $self->{'dom'};
    }

    my $src  = $self->text;
    my $node = CommonMark->parse( string => $src );

    my $html = $node->render( format => 'html', unsafe => 1 );

    $self->{'dom'} = $parser->parse($html);

    return $self->{'dom'};
  }

  $self->{'dom'} = shift @_;
  return $self->{'dom'};
}

sub expand_inline_ruby {
  my $self = shift;

  for my $node ( $self->dom->find('p, li, dt, dd')->@* ) {
    my $html = $node->html;
    $html =~ s!\{([^}]+)\}!_expand_inline_ruby($1)!ges;
    $node->replace( $parser->parse($html)->at('body > *:first-child') );
  }

  return $self->dom;
}

sub _expand_inline_ruby {
  my $src = shift;

  my @seg = split qr{\|}, $src;

  if ( @seg == 2 ) {
    my ( $txt, $rt ) = @seg;
    return qq{<ruby>${txt}<rp>（</rp><rt>${rt}</rt><rp>）</rp></ruby>};
  }

  my @text = split q{}, ( shift @seg );
  my $out  = '<ruby>';

  while ( defined( my $txt = shift @text ) ) {
    my $rt = shift @seg;

    if ( defined $rt ) {
      $out .= "${txt}<rt>${rt}</rt>";
    }
  }

  $out .= '</ruby>';

  return $out;
}

sub expand_block_image {
  my $self = shift;

  for my $node ( $self->dom->find('p > img:only-child')->@* ) {
    my $src   = $node->getAttribute('src');
    my $label = $node->getAttribute('alt');

    my $path = URI->new( $src, 'https' )->path;
    my $img  = Kalaclista::Image->new( source => $self->src->child($path) );

    $self->dst->mkpath;
    $img->resize( $self->dst );

    my $width  = $img->width;
    my $height = $img->height;

    my $x1 = $src;
    $x1 =~ s{\.[^\.]+$}{_1x.png};

    my $x2 = $src;
    $x2 =~ s{\.[^\.+]+$}{_2x.png};

    my $html = <<"...";
<p class="img">
  <a href="" title="${label}">
    <img  alt="${label}"
          src="${src}"
          srcset="${x1} 1x, ${x2} 2x"
          width="${width}"
          height="${height}" />
  </a>
</p>
...

    my $dom = $parser->parse($html)->at('p.img');

    $node->replace($dom);
  }

  return $self->dom;
}

1;
