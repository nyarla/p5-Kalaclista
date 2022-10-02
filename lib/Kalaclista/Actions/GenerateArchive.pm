package Kalaclista::Actions::GenerateArchive;

use strict;
use warnings;

use Kalaclista::Entries;
use Kalaclista::Parallel::Tasks;

use Path::Tiny;

sub action {
  my ( $class, $ctx ) = @_;

  my $content = $ctx->dirs->content_dir->stringify;
  my $baseURI = $ctx->baseURI;
  my $dist    = $ctx->dirs->distdir;

  my $loader = Kalaclista::Entries->new( $content, $baseURI );
  my @pages =
      map { $_->baseURI($baseURI); $_ } $ctx->query( archives => $loader->entries->@* );

  my $generator = Kalaclista::Parallel::Tasks->new(
    threads => $ctx->threads,
    handle  => sub {
      local $@;
      eval { shift->emit; };

      if ($@) {
        return { ERROR => $@ };
      }

      return {};
    },
    result => sub {
      my $result = shift;
      if ( exists $result->{'ERROR'} ) {
        print STDERR $result->{'ERROR'};
      }

      return $result;
    }
  );

  return $generator->run(@pages);
}

1;
