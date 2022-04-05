package Kalaclista::Config::Kalaclista;

use strict;
use warnings;

use Kalaclista::Directory;

use Exporter 'import';

our @EXPORT_OK = qw(dirs);

my $dirs = Kalaclista::Directory->instance(
  assets  => 'private/assets',
  content => 'private/content',
  data    => 'private/cache',
  dist    => 'dist',
);

sub dirs {
  return $dirs;
}

1;

=pod

=head1 NAME

Kalaclista::Config::Kalaclista - Configuration file for L<https://the.kalaclista.com/>

=cut
