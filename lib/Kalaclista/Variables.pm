package Kalaclista::Variables;

use strict;
use warnings;

use Class::Accessor::Lite (
  new => 1,
  rw  =>
    [qw( title website description section kind data entries href breadcrumb )],
);

1;
