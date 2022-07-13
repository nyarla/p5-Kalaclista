#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::HyperScript qw(p hr link_ true false raw);

sub main {

  # black element
  is( hr, "<hr />" );

  # element attribute
  is( hr( { class => [qw(foo bar')] } ), qq(<hr class="bar&#39; foo" />) );
  is(
    hr( { data => { foo => 'bar', bar => 'baz' } } ),
    qq(<hr data-bar="baz" data-foo="bar" />)
  );
  is( link_( { crossorigin => true } ), qq(<link crossorigin />) );
  is( link_( { crossorigin => true }, { crossorigin => false } ),
    qq(<link />) );
  is( hr( { class => 'foo bar' } ), qq(<hr class="foo bar" />) );

  # element with child content
  is( p(qw( foo bar baz )),                 qq(<p>foobarbaz</p>) );
  is( p( { class => 'foo' }, qw(bar baz) ), qq(<p class="foo">barbaz</p>) );

  # auto escaped text
  is( p("I'm bot"), qq(<p>I&#39;m bot</p>) );

  # raw text
  is( p( raw("I'm bot") ), qq(<p>I'm bot</p>) );

  done_testing;
}

main;
