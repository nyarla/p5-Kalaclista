package Kalaclista::Actions::GenerateIndex;

use strict;
use warnings;

use Kalaclista::Entries;

sub action {
  my ( $class, $c ) = @_;

  my $content = $c->dirs->content_dir->stringify;
  my $baseURI = $c->baseURI;
  my $dist    = $c->dirs->distdir;

  my $loader = Kalaclista::Entries->new( $content, $baseURI );
  $loader->fixup( sub { return $c->call( fixup => shift ) } );

  for my $page ( $c->query( archives => $loader->entries->@* ) ) {
    $page->baseURI($baseURI);
    $page->emit;
  }

  return 1;
}

1;
