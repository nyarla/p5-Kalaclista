use v5.38;
use builtin qw(true false);
use feature qw(class state);
no warnings qw(experimental);

use Text::CSV;
use URI::Escape::XS;

class Kalaclista::Data::WebSite::Loader {
  field $path : param = q{};
  field $websites = undef;

  method load {
    my $href = shift;

    if ( !defined $websites ) {
      $websites = {};
      my $csv = Text::CSV::csv( in => $path );
      shift $csv->@*;    # strip header line

      for my $row ( $csv->@* ) {
        my ( $action, $locked, $gone, $unixtime, $status, $title, $link, $permalink, $summary ) = $row->@*;
        my $data = {
          gone      => $gone eq 'yes',
          title     => $title,
          link      => $link,
          permalink => $permalink,
          summary   => $summary,
        };

        $websites->{$link}      = $data;
        $websites->{$permalink} = $data;
      }
    }

    return $websites->{$href} if exists $websites->{$href};
    return;
  }
}

class Kalaclista::Data::WebSite {
  field $title : param     = q{};
  field $summary : param   = q{};
  field $link : param      = q{};
  field $permalink : param = q{};
  field $gone : param      = false;
  field $cite              = undef;

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

    $info->{'title'} //= $text;
    return $class->new( $info->%* );
  }
}
