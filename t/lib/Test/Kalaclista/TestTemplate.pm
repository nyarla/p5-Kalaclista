package Test::Kalaclista::TestTemplate;

use strict;
use warnings;

use Test2::V0;

sub render {
  my $vars = shift;

  isa_ok( $vars, 'Kalaclista::Variables' );

  return 'ok';
}

1;
