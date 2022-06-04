#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::HyperStyle qw(css);
use YAML::Tiny;

sub main {
  is( css( [ p => [ fontSize => '1em' ] ] ), 'p{font-size:1em;}' );

  my $in  = [ p => [ fontSize => '1em' ] ];
  my $out = q<p{font-size:1em;}>;

  for ( 1 .. 100 ) {
    $in  = [ p => $in ];
    $out = "p " . $out;
  }

  is( css($in), $out );

  is(
    css(
      [
        p => [
          fontSize   => '1em',
          p          => [ fontSize => '1em' ],
          fontWeight => 'bold'
        ],
      ]
    ),
    "p{font-size:1em;font-weight:bold;}p p{font-size:1em;}"
  );

  is(
    css(
      [
        [qw( p li )] => [ em => [ fontSize => '1em' ] ],
      ]
    ),
    "p em,li em{font-size:1em;}",
  );

  is(
    css(
      [
        [qw(p li)] => [ em => [ [qw(a img)] => [ backgroundColor => 'blue' ] ] ]
      ],
    ),

    "p em a,p em img,li em a,li em img{background-color:blue;}"
  );

  done_testing;
}

main;
