use v5.38;
use builtin qw(true false);
use feature qw(class state);
no warnings qw(experimental);

use URI::Fast;

use Kalaclista::Data::Directory;
use Kalaclista::Data::WebSite;

class Kalaclista::Context {
  field $baseURI : param;
  field $dirs : param;
  field $production : param;
  field $website : param  = undef;
  field $sections : param = undef;

  sub init {
    my $class = shift;
    my %args  = @_;

    my $uri  = URI::Fast->new( $args{'baseURI'} );
    my $dir  = Kalaclista::Data::Directory->instance( $args{'dirs'}->%* );
    my $prod = !!( delete $args{'production'} );

    my $instance = $class->new(
      baseURI    => $uri,
      dirs       => $dir,
      production => $prod,
    );

    $class->instance($instance);
  }

  sub instance {
    shift;
    state $instance;

    if ( @_ > 0 ) {
      $instance = shift;
    }

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

  method website {
    if ( @_ > 0 ) {
      $website = Kalaclista::Data::WebSite->new(@_);
    }

    return $website;
  }

  method sections {
    if ( @_ > 0 ) {
      my %args = @_;

      for my $section ( sort keys %args ) {
        $sections //= {};
        $sections->{$section} = Kalaclista::Data::WebSite->new( $args{$section}->%* );
      }
    }

    return $sections;
  }
}
