package Kalaclista::Actions::RunningTest;

use strict;
use warnings;
use utf8;

use Test2::V0;

sub action {
  my $class = shift;
  my $ctx   = shift;

  isa_ok( $ctx,          'Kalaclista::Context' );
  isa_ok( $ctx->baseURI, 'URI::Fast' );

  is( $ctx->threads, 3 );
}

1;
