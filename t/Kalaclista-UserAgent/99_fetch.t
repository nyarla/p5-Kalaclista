#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempfile);
use YAML::XS;

use Kalaclista::UserAgent;

my $dist = tempfile;
my $ua   = 'Mozilla/5.0 (X11; Linux x86_64; rv:98.0) Gecko/20100101 Firefox/98.0';

sub main {
  my $agent = Kalaclista::UserAgent->new( agent => $ua );

  my $href    = 'http://kalaclista.com/';
  my $content = $agent->fetch( $href => $dist );

  ok( $content ne q{} );

  ok( $dist->is_file );

  my $data = YAML::XS::LoadFile( $dist->stringify );
  ok($data);
  is( ref $data, 'HASH' );

  ok( !$data->{'has_redirect'} );

  done_testing;
}

main;
