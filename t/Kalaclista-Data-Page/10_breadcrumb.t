#!/usr/bin/env perl

use strict;
use warnings;

use Kalaclista::Data::Page;

use Test2::V0;

subtest new => sub {
  my $breadcrumb = Kalaclista::Data::Page::Breadcrumb->new;

  isa_ok( $breadcrumb, 'Kalaclista::Data::Page::Breadcrumb' );
};

subtest accessors => sub {
  my $b = Kalaclista::Data::Page::Breadcrumb->new;

  $b->push( label => 'test' );

  is $b->length, 1, 'this value should be `1`';

  isa_ok( $b->index(0), 'Kalaclista::Data::WebSite' );
};

done_testing;
