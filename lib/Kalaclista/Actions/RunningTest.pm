package Kalaclista::Actions::RunningTest;

use strict;
use warnings;
use utf8;

use Test2::V0;

sub action {
  my $class = shift;
  my $app   = shift;

  isa_ok( $app,                  'Kalaclista::Application' );
  isa_ok( $app->config,          'Kalaclista::Config' );
  isa_ok( $app->config->baseURI, 'URI' );

  is( $app->config->threads, 3 );
}

1;
