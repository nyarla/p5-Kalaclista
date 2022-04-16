package Kalaclista::Entry::Content;

use strict;
use warnings;
use utf8;

use CommonMark;
use HTML5::DOM;

use Class::Accessor::Lite ( rw => [qw( src html md dom )], );

my $parser = HTML5::DOM->new(
  {
    script => 1,
  }
);

sub new {
  my $class = shift;
  my $src   = shift;

  my $self = bless {}, $class;
  my $md   = CommonMark->parse( string => $src );
  my $html = $md->render( format => 'html', unsafe => 1 );
  my $dom  = $parser->parse($html);

  $self->src($src);
  $self->md($md);
  $self->html($html);
  $self->dom($dom);

  return $self;
}

1;
