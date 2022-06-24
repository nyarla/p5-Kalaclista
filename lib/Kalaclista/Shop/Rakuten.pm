package Kalaclista::Shop::Rakuten;

use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( label search width height image shop )],
);

use URI::Escape qw( uri_escape_utf8 );

sub link {
  my $self = shift;

  if ( defined( my $shop = $self->shop ) ) {
    return $shop if ( $shop ne q{} );
  }

  if ( !exists $self->{'link'} || $self->{'link'} eq q{} ) {
    my $search = $self->search;
    $search =~ s{ +}{+}g;

    my $link = "https://search.rakuten.co.jp/search/mall/${search}/";
    my $href =
"https://hb.afl.rakuten.co.jp/hgc/0d591c80.1e6947ee.197d1bf7.7a323c41/?pc=@{[ uri_escape_utf8($link) ]}&link_type=text&ut=eyJwYWdlIjoidXJsIiwidHlwZSI6InRleHQiLCJjb2wiOjF9";

    $self->{'link'} = $href;
  }

  return $self->{'link'};
}

1;
