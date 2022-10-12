package Kalaclista::WebSite;

use strict;
use warnings;
use utf8;

use Class::Accessor::Lite ( new => 1, rw => [qw( href title summary )] );

use HTML5::DOM;
use YAML::XS;
use Carp qw(confess);

my $parser = HTML5::DOM->new;

sub parse {
  my $class   = shift;
  my $content = shift;

  my $dom   = $parser->parse($content);
  my $title = _get(
    $dom,
    [ 'attr', 'meta[property="og:title"]',  'content' ],
    [ 'attr', 'meta[name="twitter:title"]', 'content' ],
    [ 'elm',  'title' ],
  );

  my $summary = _get(
    $dom,
    [ 'attr', 'meta[property="og:description"]',  'content' ],
    [ 'attr', 'meta[name="twitter:description"]', 'content' ],
    [ 'attr', 'meta[name="description"]',         'content' ],
  );

  return $class->new(
    title   => $title,
    summary => $summary,
  );
}

sub emit {
  my $self = shift;
  my $file = shift;

  my %data;
  @data{qw( href title summary )} = ( $self->href, $self->title, $self->summary );

  my $yaml = YAML::XS::Dump( \%data );

  return $file->spew($yaml);
}

sub _get {
  my $dom   = shift;
  my @tasks = shift;

  for my $task (@tasks) {
    if ( $task->[0] eq 'attr' ) {
      my $el = $dom->at( $task->[1] );
      if ( defined $el ) {
        return $el->getAttribute( $task->[2] );
      }
    }

    if ( $task->[0] eq 'elm' ) {
      my $el = $dom->at( $task->[1] );
      if ( defined $el ) {
        return $el->textContent;
      }
    }
  }

  return q{};
}

1;
