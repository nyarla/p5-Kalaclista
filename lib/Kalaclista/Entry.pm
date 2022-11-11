package Kalaclista::Entry;

use strict;
use warnings;
use utf8;

use feature qw(state);

use CommonMark;
use HTML5::DOM;
use URI::Fast;
use YAML::XS;

my $parser = HTML5::DOM->new( { script => 1 } );

use Class::Accessor::Lite (
  ro => [qw( path transformers )],
  rw => [qw( href loaded parsed meta yaml markdown )],
);

BEGIN {
  no strict 'refs';
  for my $prop (qw( title type slug date )) {
    *{ __PACKAGE__ . "::${prop}" } = sub {
      my $self = shift;
      return $self->meta->{$prop}
          if ( exists $self->meta->{$prop} && defined $self->meta->{$prop} );

      if ( defined( my $new = shift @_ ) ) {
        $self->meta->{$prop} = $new;
        return $new;
      }

      $self->load->parse;

      return $self->meta->{$prop}
          if ( exists $self->meta->{$prop} && defined $self->meta->{$prop} );

      return q{};
    };
  }

  use strict 'refs';
}

sub new {
  my $class = shift;
  my $path  = shift;

  state $cache ||= {};

  return $cache->{$path}
      if ( exists $cache->{$path} && ref $cache->{$path} eq 'Kalaclista::Entry' );

  my $href = shift;
  my $self = bless {
    path         => $path,
    href         => $href,
    meta         => {},
    transformers => [],
    addon        => {},
  }, $class;

  $cache->{$path} = $self;

  return $self;
}

sub load {
  my $self = shift;
  return $self if ( defined $self->loaded && $self->loaded );

  open( my $fh, '<:encoding(UTF-8)', $self->path )
      or die "failed to open entry: @{[ $self->path ]}: $!";

  my $yaml   = q{};
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

    $yaml .= "${line}\n";
  }

  my $md = do { local $/; <$fh> };

  close($fh)
      or die "failed to close entry: @{[ $self->path ]}: $!";

  utf8::encode($yaml);

  $self->yaml($yaml);
  $self->markdown($md);

  $self->loaded(1);

  return $self;
}

sub parse {
  my $self = shift;

  return $self if ( defined $self->parsed && $self->parsed );

  $self->meta( YAML::XS::Load( $self->yaml ) );
  $self->parsed(1);
  return $self;
}

sub lastmod {
  my $self = shift;
  return $self->meta->{'lastmod'}
      if ( exists $self->meta->{'lastmod'} && defined $self->meta->{'lastmod'} );

  if ( defined( my $new = shift @_ ) ) {
    $self->meta->{'lastmod'} = $new;
    return $new;
  }

  $self->load->parse;
  return $self->meta->{'lastmod'}
      if ( exists $self->meta->{'lastmod'} && defined $self->meta->{'lastmod'} );

  $self->meta->{'lastmod'} //= $self->date;
  return $self->date;
}

sub dom {
  my $self = shift;
  return $self->{'dom'}
      if ( exists $self->{'dom'} && defined $self->{'dom'} );

  if ( defined( my $new = shift @_ ) ) {
    $self->{'dom'} = $new;
    return $new;
  }

  $self->load;

  my $node = CommonMark->parse( string => $self->markdown );
  my $html = $node->render( format => 'html', unsafe => 1 );
  my $dom  = $parser->parse($html)->body;

  $self->{'dom'} = $dom;

  return $dom;
}

sub register {
  my $self = shift;

  for my $transfomer (@_) {
    die "transformer is not CODE reference." if ( ref $transfomer ne 'CODE' );

    push $self->{'transformers'}->@*, $transfomer;
  }

  return $self;
}

sub transform {
  my $self = shift;

  for my $transfomer ( $self->{'transformers'}->@* ) {
    $transfomer->( $self, $self->dom );
  }

  return $self;
}

sub addon {
  my $self = shift;
  my $key  = shift // q{default};

  if ( defined( my $new = shift ) ) {
    $self->{'addon'}->{$key} = $new;
    return $new;
  }

  return $self->{'addon'}->{$key};
}

1;
