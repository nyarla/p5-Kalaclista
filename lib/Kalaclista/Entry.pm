package Kalaclista::Entry;

use strict;
use warnings;
use utf8;

use Kalaclista::HTML5;

use Carp qw(confess);
use CommonMark;
use Path::Tiny;
use URI;
use YAML::Tiny;

sub new {
  my ( $class, $path, $href ) = @_;

  return bless {
    path   => $path,
    loaded => 0,
    parsed => 0,
    src    => {
      meta    => q{},
      content => q{},
    },
    href     => $href,
    props    => {},
    dom      => undef,
    registry => [],
  }, $class;
}

sub loaded { return !!$_[0]->{'loaded'} }
sub parsed { return !!$_[0]->{'parsed'} }
sub href   { return $_[0]->{'href'} }

sub load {
  my ($self) = @_;

  if ( !$self->loaded ) {
    my ( $yaml, $md ) = ( q{}, q{} );
    open( my $fh, '<:encoding(UTF-8)', $self->{'path'} )
        or confess( "failed to open file: " . $self->{'path'} . ' :' . $! );

    my $inside = 0;
    while ( defined( my $line = <$fh> ) ) {
      chomp($line);

      if ( $line eq q{---} ) {
        if ( $inside == 0 ) {
          $inside++;
          next;
        }

        if ( $inside > 0 ) {
          last;
        }
      }

      $yaml .= $line . "\n";
    }

    $md = do { local $/; <$fh> };

    close($fh)
        or confess( "failed to open file: " . $self->{'path'} . ' :' . $! );

    $self->{'src'}->{'meta'}    = $yaml;
    $self->{'src'}->{'content'} = $md;
    $self->{'loaded'}           = 1;
  }

  return $self;
}

sub parse {
  my $self = shift;

  if ( !$self->parsed ) {
    $self->{'props'}           = YAML::Tiny::Load( $self->{'src'}->{'meta'} );
    $self->{'props'}->{'href'} = URI->new( $self->{'props'}->{'href'} );
    $self->{'parsed'}          = 1;
  }

  return $self;
}

sub title {
  my $self = shift;

  if ( defined( my $new = shift ) ) {
    $self->{'props'}->{'title'} = $new;
  }

  $self->load  if ( !$self->loaded );
  $self->parse if ( !$self->parsed );

  return $self->{'props'}->{'title'} // q{};
}

sub type {
  my $self = shift;

  if ( defined( my $new = shift ) ) {
    $self->{'props'}->{'type'} = $new;
  }

  $self->load  if ( !$self->loaded );
  $self->parse if ( !$self->parsed );

  return $self->{'props'}->{'type'} // q{};
}

sub slug {
  my $self = shift;

  if ( defined( my $new = shift ) ) {
    $self->{'props'}->{'slug'} = $new;
  }

  $self->load  if ( !$self->loaded );
  $self->parse if ( !$self->parsed );

  return $self->{'props'}->{'slug'} // q{};
}

sub date {
  my $self = shift;

  if ( defined( my $new = shift ) ) {
    $self->{'props'}->{'date'} = $new;
  }

  $self->load  if ( !$self->loaded );
  $self->parse if ( !$self->parsed );

  return $self->{'props'}->{'date'} // q{};
}

sub lastmod {
  my $self = shift;

  if ( defined( my $new = shift ) ) {
    $self->{'props'}->{'lastmod'} = $new;
  }

  $self->load  if ( !$self->loaded );
  $self->parse if ( !$self->parsed );

  return $self->{'props'}->{'lastmod'} // $self->date // q{};
}

sub dom {
  my $self = shift;

  $self->load if ( !$self->loaded );

  if ( !defined $self->{'dom'} ) {
    my $node = CommonMark->parse( string => $self->{'src'}->{'content'} );
    my $html = $node->render( format => 'html', unsafe => 1 );
    $self->{'dom'} = Kalaclista::HTML5->parse($html)->body;
  }

  return $self->{'dom'};
}

sub register {
  my ( $self, $processor ) = @_;

  if ( !ref $processor eq 'CODE' ) {
    confess 'processor is node CodeRef';
  }

  push $self->{'registry'}->@*, $processor;

  return $self;
}

sub transform {
  my $self = shift;

  for my $processor ( $self->{'registry'}->@* ) {
    $processor->( $self, $self->dom );
  }

  return $self;
}

1;
