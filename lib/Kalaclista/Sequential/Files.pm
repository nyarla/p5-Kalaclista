use strict;
use warnings;

package Kalaclista::Sequential::Files;

use Path::Tiny::Glob;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( process result )],
);

sub run {
  my $self  = shift;
  my @globs = @_;

  my $files = pathglob( \@globs );
  my @results;
  while ( defined( my $file = $files->next ) ) {
    push @results, $self->process->( $self, $file );
  }

  return $self->result->( $self, @results );
}

1;
