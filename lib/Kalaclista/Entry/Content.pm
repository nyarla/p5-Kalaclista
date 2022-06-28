package Kalaclista::Entry::Content;

use strict;
use warnings;
use utf8;

use Carp qw(confess);
use Path::Tiny;
use CommonMark;
use HTML5::DOM;

use Class::Accessor::Lite(
  new => 1,
  ro  => [qw(dom)],
);

my $parser = HTML5::DOM->new(
  {
    script => 1,
  }
);

sub load {
  my $class = shift;
  my $args  = ref $_[0] ? $_[0] : {@_};

  my $src = delete $args->{'src'};

  if ( !defined $src ) {
    confess 'argument `src` does not specified';
  }

  $src = path("${src}") if ( ref $src eq 'Path::Tiny' );

  my $commonmark = $src->slurp_utf8;
  my $node       = CommonMark->parse( string => $commonmark );
  my $html       = $node->render( format => 'html', unsafe => 1 );
  my $dom        = $parser->parse($html);

  return $class->new( dom => $dom->body );
}

sub transform {
  my $self        = shift;
  my $transformer = shift;

  if ( !ref $transformer eq 'CODE' ) {
    confess 'transformer is not CODE reference';
  }

  return $transformer->( $self->dom );
}

1;
