package Kalaclista::Actions::GenerateEntries;

use strict;
use warnings;

use Kalaclista::Entries;

sub action {
  my ( $class, $c ) = @_;

  my $content = $c->dirs->content_dir->stringify;
  my $baseURI = $c->baseURI;
  my $distdir = $c->dirs->distdir;

  my $loader = Kalaclista::Entries->new( $content, $baseURI );
  $loader->fixup( sub { return $c->call( fixup => shift ) } );

  for my $entry ( $loader->entries->@* ) {
    $entry->transform;

    my $page = $c->query( page => $entry );
    $page->baseURI($baseURI);
    $page->emit;
  }

  return 1;
}

1;
