use strict;
use warnings;
use utf8;

use Kalaclista::Directory;

my $dirs = Kalaclista::Directory->instance;

my $config =
  { dirs => $dirs, call => {}, query => {}, data => {} };

$config;
