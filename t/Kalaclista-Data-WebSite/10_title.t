#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Data::WebSite;

subtest 'it should return $title content' => sub {
  my $web = Kalaclista::Data::WebSite->new( title => 'hello, world!' );

  is $web->title, 'hello, world!';
};

subtest 'it should return $summary value' => sub {
  my $web = Kalaclista::Data::WebSite->new( summary => 'my web site' );

  is $web->summary, 'my web site';
};

subtest 'it should fallback to $title content' => sub {
  my $web = Kalaclista::Data::WebSite->new( title => 'hello' );

  is $web->summary, 'hello';
};

done_testing;
