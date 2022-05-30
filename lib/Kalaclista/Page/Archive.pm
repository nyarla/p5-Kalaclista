package Kalaclista::Page::Archive;

use strict;
use warnings;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( out template vars )],
  rw  => [qw( baseURI )],
);

use Kalaclista::Template;
use Path::Tiny;

sub emit {
  my $self     = shift;
  my $template = load( 'Archives', $self->template );

  if ( ref $template ne 'CODE' ) {
    return { ERROR => $template };
  }

  my $html =
    $template->( $self->vars, $self->baseURI, path( $self->template )->parent );

  $self->out->parent->mkpath;
  $self->out->spew_utf8($html);

  return {};
}

1;
