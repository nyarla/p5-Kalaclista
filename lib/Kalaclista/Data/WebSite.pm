use v5.38;
use builtin qw(true false);
use feature qw(class state);
no warnings qw(experimental);

use YAML::XS;
use URI::Escape::XS;

class Kalaclista::Data::WebSite::Loader {
  field $path : param = q{};
  field $final = undef;

  method load {
    my $href = shift;

    if ( !defined $final ) {
      $final = {};

      my $websites = YAML::XS::LoadFile($path);

      for my $link ( sort keys $websites->%* ) {
        $final->{$link} = $websites->{$link};

        if ( exists $websites->{$link}->{'permalink'} && defined( my $permalink = $websites->{$link}->{'permalink'} ) ) {
          $final->{$permalink} = $websites->{$link};
        }
      }
    }

    return $final->{$href} if exists $final->{$href};
    return;
  }
}

class Kalaclista::Data::WebSite {
  field $label : param     = q{};
  field $title : param     = q{};
  field $summary : param   = q{};
  field $link : param      = q{};
  field $permalink : param = q{};
  field $gone : param      = false;
  field $cite              = undef;

  method label {
    return $label if $label ne q{};
    return;
  }

  method title {
    return $title if $title ne q{};
    return;
  }

  method summary {
    return $summary if $summary ne q{};
    return $title   if $title ne q{};
    return;
  }

  method permalink {
    return $permalink if $permalink ne q{};
    return $link      if $link ne q{};
    return;
  }

  method cite {
    return $cite if defined $cite;

    $cite = URI::Escape::XS::uri_unescape( $self->permalink );
    utf8::decode($cite);

    return $cite;
  }

  method gone {
    return $gone;
  }

  sub init {
    shift->loader(shift);
  }

  sub loader {
    state $loader;
    return $loader if defined $loader;

    shift;
    my $path = shift;
    $loader = Kalaclista::Data::WebSite::Loader->new( path => $path );

    return $loader;
  }

  sub load {
    my $class = shift;
    my $args  = ref $_[0] ? $_[0] : {@_};

    my ( $text, $href ) = @{$args}{qw/ text href /};

    my $info = $class->loader->load($href);
    return $class->new( title => $text, link => $href ) if !$info;

    delete $info->{$_} for (qw[ lock status action updated ]);

    $info->{'title'} //= $text;
    $info->{'link'}  //= $href;

    return $class->new( $info->%* );
  }
}
