package Kalaclista::Actions::GenerateArchive;

use strict;
use warnings;

use Kalaclista::Sequential::Files;
use Kalaclista::Parallel::Tasks;
use Kalaclista::Entry::Meta;
use Kalaclista::Files;
use Kalaclista::Utils qw( make_fn make_href );
use Path::Tiny;

sub makeHandle {
  my ($context) = @_;

  my $build   = $context->dirs->build_dir->child('contents');
  my $baseURI = $context->baseURI;

  return sub {
    my $file = shift;
    my $fn   = make_fn $file->stringify, $build->stringify;
    my $href = make_href $fn, $baseURI;

    my $meta = Kalaclista::Entry::Meta->load(
      src  => $file,
      href => $href,
    );

    $context->call( fixup => $meta );

    return $meta;
  };
}

sub files {
  my ( $class, $rootdir ) = @_;
  return map { path($_) }
    grep { $_ =~ m{\.yaml$} } Kalaclista::Files->find($rootdir);
}

sub action {
  my $class   = shift;
  my $context = shift;

  my $content = $context->dirs->content_dir;
  my $build   = $context->dirs->build_dir->child('contents');
  my $dist    = $context->dirs->distdir;

  my $baseURI = $context->baseURI;

  my $loader = Kalaclista::Sequential::Files->new(
    handle => makeHandle($context),
    result => sub {
      return @_;
    }
  );

  my @entries = $loader->run( $class->files( $build->stringify ) );
  my @pages =
    map { $_->baseURI($baseURI); $_ } $context->query( archives => @entries );

  my $generator = Kalaclista::Parallel::Tasks->new(
    handle => sub { shift->emit; {} },
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
