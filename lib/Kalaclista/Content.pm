package Kalaclista::Content;

use strict;
use warnings;
use utf8;

use CommonMark;
use HTML5::DOM;

use Class::Accessor::Lite (
  new => 1,
  rw  => [qw( title type date lastmod slug source )],
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

    my $src  = $self->source;
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

1;
