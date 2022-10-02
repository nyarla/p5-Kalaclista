package Kalaclista::Actions::GeneratePermalink;

use strict;
use warnings;

use Kalaclista::Entries;
use Kalaclista::Parallel::Tasks;

sub action {
  my ( $class, $ctx ) = @_;

  my $dist    = $ctx->dirs->distdir;
  my $content = $ctx->dirs->content_dir->stringify;

  my $baseURI = $ctx->baseURI;
  my $loader  = Kalaclista::Entries->new( $content, $baseURI );

  my @pages = map {
    $ctx->call( fixup => $_ );
    my $page = $ctx->query( page => $_ );
    $page->baseURI($baseURI);
    $page
  } $loader->entries->@*;

  my $builder = Kalaclista::Parallel::Tasks->new(
    handle => sub { shift->emit; {} },
    result => sub {
      my $result = shift;
      if ( exists $result->{'ERROR'} ) {
        print STDERR $result->{'ERROR'};
      }

      return $result;
    },
    threads => $ctx->threads,
  );

  return $builder->run(@pages);
}

1;
