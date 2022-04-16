package Kalaclista::Config::Kalaclista;

use strict;
use warnings;

use Kalaclista::Config;
use Kalaclista::Directory;

use Exporter 'import';

our @EXPORT_OK = qw(config);

my $dirs = Kalaclista::Directory->instance(
  dist    => 'dist/the.kalaclista.com',
  data    => 'private/the.kalaclista.com/cache',
  assets  => 'private/the.kalaclista.com/assets',
  content => 'private/the.kalaclista.com/content',
  build   => 'resources',
);

my $config = Kalaclista::Config->new( dirs => $dirs, );

sub config { $config }

1;
