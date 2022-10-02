package Kalaclista::HTML5;

use strict;
use warnings;
use utf8;

use HTML5::DOM;

my $parser = HTML5::DOM->new( { script => 1 } );

sub parse {
  return $parser->parse( $_[1] );
}

1;
