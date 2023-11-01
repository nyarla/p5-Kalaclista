use v5.38;
use builtin qw(true false);
use feature qw(class state);
no warnings qw(experimental);

use Carp;
use HTML5::DOM;
use URI::Fast;
use YAML::XS;

use Kalaclista::Path;

class Kalaclista::Entry {
  field $path : param         = q{};
  field $transformers : param = [];

  field $href : param : = undef;
  field $loaded : param = false;

  field $meta : param = {};
  field $src : param  = q{};
  field $dom : param  = undef;

  field $parser = HTML5::DOM->new( { script => 1 } );

  method loaded { return $loaded }

  method load {
    return $self if $loaded;

    open( my $fh, '<:encoding(UTF-8)', $self->path->path )
        or die "failed to open entry file: @{[ $self->path ]}: ${!}";

    my $yaml  = q{};
    my $lines = 0;

    while ( defined( my $line = <$fh> ) ) {
      chomp($line);

      if ( $line =~ m{^---+$} ) {
        if ( $lines == 0 ) {
          $lines++;
          next;
        }

        if ( $lines > 0 ) {
          last;
        }
      }

      $yaml .= $line . "\n";
    }

    $src = do { local $/; <$fh> };

    close($fh) or die "failed to close entry file: @{[ $self->path ]}${$!}";

    $meta = {
      $meta->%*,
      YAML::XS::Load($yaml)->%*,
    };

    $loaded = true;
    return true;
  }

  method href {
    if ( @_ == 0 ) {
      return undef if !$href || $href eq {};
      return $href if ref $href eq 'URI::Fast';

      if ( !ref $href ) {
        $href = URI::Fast->new($href);
      }

      return $href;
    }

    my $new = shift;
    if ( !$new || $new eq q{} ) {
      Carp::croak("argument should be string or instance URI::Fast");
    }

    if ( !ref $new ) {
      $new = URI::Fast->new($new);
    }

    $href = $new;

    return $href;
  }

  method path {
    if ( @_ == 0 ) {
      return undef if !$path || $path eq q{};
      return $path if $path eq 'Kalaclista::Path';

      if ( !ref $path ) {
        $path = Kalaclista::Path->new( path => $path );
      }

      return $path;
    }

    my $new = shift;
    if ( !$new || $new eq q{} ) {
      Carp::croak("argument should be string or instance of Kalaclista::Path");
    }

    if ( !ref $new ) {
      $new = Kalaclista::Path->new( path => $new );
    }

    $path = $new;
    return $path;
  }

  method src {
    if ( @_ == 0 ) {
      return $src;
    }

    my $new = shift;
    $new = "${new}";
    $src = $new;

    return $src;
  }

  method dom {
    if ( @_ == 0 ) {
      return undef if $src eq q{};

      $dom = $parser->parse($src)->body;
      return $dom;
    }

    my $new = shift;
    if ( ref $new =~ m{^HTML5::DOM} ) {
      $dom = $new;
      return $dom;
    }

    $src = "${new}";
    $dom = $parser->parse($src)->body;
    return $dom;
  }

  method add_transformer {
    push $transformers->@*, shift;
  }

  method transform {
    for my $transformer ( $transformers->@* ) {
      $transformer->($self);
    }

    return $self;
  }

  method meta {
    my $key = shift;
    if ( @_ > 0 ) {
      $meta->{$key} = shift;
    }

    if ( exists $meta->{$key} ) {
      return $meta->{$key};
    }

    return undef;
  }

  method title   { $self->meta( 'title'   => @_ ) }
  method summary { $self->meta( 'summary' => @_ ) }
  method type    { $self->meta( 'type'    => @_ ) }
  method slug    { $self->meta( 'slug'    => @_ ) }
  method date    { $self->meta( 'date'    => @_ ) }
  method lastmod { $self->meta( 'lastmod' => @_ ) }
}
