use v5.38;
use builtin qw(true false);
use feature qw(class state);
no warnings qw(experimental);

use URI::Fast;

use Kalaclista::Data::Directory;

class Kalaclista::Context {
  field $baseURI : param;
  field $dirs : param;
  field $production : param;

  sub init {
    my $class = shift;
    my %args  = @_;

    my $baseURI    = URI::Fast->new( $args{'baseURI'} );
    my $dirs       = Kalaclista::Data::Directory->instance( $args{'dirs'}->%* );
    my $production = !!( delete $args{'production'} );

    my $instance = $class->new(
      baseURI    => $baseURI,
      dirs       => $dirs,
      production => $production,
    );

    $class->instance($instance);
  }

  sub instance {
    shift;
    state $instance ||= shift;

    return $instance;
  }

  method baseURI {
    return $baseURI;
  }

  method dirs {
    return $dirs;
  }

  method production {
    return $production;
  }
}
