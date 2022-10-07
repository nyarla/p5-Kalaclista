package Kalaclista::Entry;

use strict;
use warnings;
use utf8;

use Kalaclista::HTML5;

use Carp qw(confess);
use CommonMark;
use Path::Tiny;
use URI::Fast;
use YAML::XS;

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
    addons   => {},
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

    utf8::encode($yaml);

    $self->{'src'}->{'meta'}    = $yaml;
    $self->{'src'}->{'content'} = $md;
    $self->{'loaded'}           = 1;
  }

  return $self;
}

sub parse {
  my $self = shift;

  if ( !$self->parsed ) {
    $self->{'props'}  = YAML::XS::Load( $self->{'src'}->{'meta'} );
    $self->{'parsed'} = 1;
  }

  return $self;
}

sub title {
  my $self = shift;

  if ( @_ == 0 ) {
    return $self->{'props'}->{'title'}
        if defined $self->{'props'}->{'title'};

    $self->load->parse;
    $self->{'props'}->{'title'} //= q{};

    return $self->{'props'}->{'title'};
  }

  $self->{'props'}->{'title'} = shift;

  return $self->{'props'}->{'title'};
}

sub type {
  my $self = shift;

  if ( @_ == 0 ) {
    return $self->{'props'}->{'type'}
        if defined $self->{'props'}->{'type'};

    $self->load->parse;
    $self->{'props'}->{'type'} //= q{};

    return $self->{'props'}->{'type'};
  }

  $self->{'props'}->{'type'} = shift;

  return $self->{'props'}->{'type'};
}

sub slug {
  my $self = shift;

  if ( @_ == 0 ) {
    return $self->{'props'}->{'slug'}
        if defined $self->{'props'}->{'slug'};

    $self->load->parse;
    $self->{'props'}->{'slug'} //= q{};

    return $self->{'props'}->{'slug'};
  }

  $self->{'props'}->{'slug'} = shift;

  return $self->{'props'}->{'slug'};
}

sub date {
  my $self = shift;

  if ( @_ == 0 ) {
    return $self->{'props'}->{'date'}
        if defined $self->{'props'}->{'date'};

    $self->load->parse;
    $self->{'props'}->{'date'} //= q{};

    return $self->{'props'}->{'date'};
  }

  $self->{'props'}->{'date'} = shift;

  return $self->{'props'}->{'date'};
}

sub lastmod {
  my $self = shift;

  if ( @_ == 0 ) {
    return $self->{'props'}->{'lastmod'}
        if defined $self->{'props'}->{'lastmod'};

    $self->load->parse;
    $self->{'props'}->{'lastmod'} //= $self->date // q{};

    return $self->{'props'}->{'lastmod'};
  }

  $self->{'props'}->{'lastmod'} = shift;

  return $self->{'props'}->{'lastmod'};
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

sub addon {
  my $self = shift;

  if ( @_ == 0 ) {
    return $self->{'addons'};
  }

  my $ns = shift;
  if ( !exists $self->{'addons'}->{$ns} || ref $self->{'addons'}->{$ns} ne q{ARRAY} ) {
    $self->{'addons'}->{$ns} = [];
  }

  return $self->{'addons'}->{$ns};
}

1;
