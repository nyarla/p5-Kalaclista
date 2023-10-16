use v5.38;
use builtin qw(true false);
use feature qw(class state);
no warnings qw(experimental);

use Kalaclista::Path;

class Kalaclista::Data::Directory {
  field $cachedir;
  field $distdir;
  field $rootdir;
  field $srcdir;

  field $cache : param = q{cache};
  field $dist : param  = q{dist};
  field $src : param   = q{src};

  sub instance {
    my $class = shift;
    state $instance ||= do {
      my %args   = @_;
      my $detect = delete $args{'detect'};

      my $instance = $class->new(%args);
      $instance->detect($detect);

      $instance;
    };

    return $instance;
  }

  method detect {
    $rootdir = Kalaclista::Path->detect(shift);
  }

  method rootdir {
    return $rootdir;
  }

  method cachedir {
    if ( !$cachedir ) {
      $cachedir = $rootdir->child($cache);
    }

    return $cachedir;
  }

  method cache {
    my $dest = shift;
    return $self->cachedir->child($dest);
  }

  method distdir {
    if ( !$distdir ) {
      $distdir = $rootdir->child($dist);
    }

    return $distdir;
  }

  method dist {
    my $dest = shift;
    return $self->distdir->child($dest);
  }

  method srcdir {
    if ( !$srcdir ) {
      $srcdir = $rootdir->child($src);
    }

    return $srcdir;
  }

  method src {
    my $dest = shift;
    return $self->srcdir->child($dest);
  }
}
