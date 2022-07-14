package Kalaclista::Page;

use strict;
use warnings;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( dist template vars )],
  rw  => [qw( baseURI )],
);

use Kalaclista::Template qw(load);

sub emit {
  my $self = shift;
  my $tmpl = load( $self->template );
  my $out  = $tmpl->( $self->vars, $self->baseURI );

  $self->dist->parent->mkpath;
  return $self->dist->spew_utf8($out);
}

1;
