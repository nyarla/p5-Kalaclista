#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::HyperScript qw(h p hr img);

sub main {
  is( h('hr'), '<hr />' );

  is( h( 'p',   'hi' ),             '<p>hi</p>' );
  is( h( 'p',   [ 'hello', "!" ] ), '<p>hello!</p>' );
  is( h( 'img', { src => 'foo', alt => "bar" } ),
    '<img alt="bar" src="foo" />' );

  is( h( 'p', { class => 'foo' }, 'hi' ),          '<p class="foo">hi</p>' );
  is( h( 'p', { class => 'foo' }, [ 'hi', "!" ] ), '<p class="foo">hi!</p>' );
  is( h( 'p', [ 'hi', "!" ], { class => 'foo' } ), '<p class="foo">hi!</p>' );

  is( hr,                                    '<hr />' );
  is( p('hi'),                               '<p>hi</p>' );
  is( p( { id => 'hey' }, 'hi' ),            '<p id="hey">hi</p>' );
  is( img( { alt => "foo", src => "bar" } ), '<img alt="foo" src="bar" />' );

  done_testing;
}

main;
