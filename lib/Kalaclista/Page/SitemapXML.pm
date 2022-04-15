package Kalaclista::Page::SitemapXML;

use strict;
use warnings;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw(baseURI srcdir)],
);

use Kalaclista::Entry::Meta;

use Kalaclista::Sequential::Files;
use Kalaclista::HyperScript qw(h);
use Kalaclista::Utils qw( make_fn make_href );

sub emit {
  my $self = shift;
  my $xml  = shift;

  my $runner = Kalaclista::Sequential::Files->new(
    handle => sub {
      my $file = shift;

      my $path = make_fn $file,   $self->srcdir;
      my $href = make_href $path, $self->baseURI;

      my $meta = Kalaclista::Entry::Meta->load(
        href => $href,
        src  => $file,
      );

      return $meta;
    },
    result => sub {
      my $fh = $xml->openw;

      print $fh '<?xml version="1.0" encoding="UTF-8"?>';
      print $fh "\n";
      print $fh h(
        'urlset',
        { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
        [
          map {
            h( 'url', [ h( 'loc', $_->href ), h( 'lastmod', $_->lastmod ) ] )
            }
            grep { $_->lastmod ne q{} } @_,
        ]
      );

      print $fh "\n";

      $fh->close;

      return 1;
    },
  );

  return $runner->run( $self->srcdir->stringify, '**', '*.yaml' );
}

1;
