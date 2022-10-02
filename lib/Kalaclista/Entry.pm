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
    href  => $href,
    props => {},
    dom   => undef,
  }, $class;
}

sub loaded { return !!$_[0]->{'loaded'} }
sub parsed { return !!$_[0]->{'parsed'} }
sub href   { return $_[0]->{'href'} }

sub load {
  my ($self) = @_;

  if ( !$self->loaded ) {
    my ( $yaml, $md ) = ( q{}, q{} );
    open( my $fh, '<', $self->{'path'} )
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

BEGIN {
  my @props = qw(
    title type slug date lastmod
  );

  no strict 'refs';
  for my $prop (@props) {
    *{ __PACKAGE__ . "::${prop}" } = sub {
      my $self = shift;

      if ( !$self->loaded ) {
        $self->load;
      }

      if ( !$self->parsed ) {
        $self->parse;
      }

      return $self->{'props'}->{$prop};
    };
  }
  use strict 'refs';
}

sub dom {
  my $self = shift;

  if ( !defined $self->{'dom'} ) {
    my $node = CommonMark->parse( string => $self->{'src'}->{'content'} );
    my $html = $node->render( format => 'html', unsafe => 1 );
    $self->{'dom'} = Kalaclista::HTML5->parse($html);
  }

  return $self->{'dom'};
}

sub transform {
  my ( $self, $processor ) = @_;

  if ( !ref $processor eq 'CODE' ) {
    confess 'processor is node CodeRef';
  }

  return $processor->( $self->dom );
}

1;
