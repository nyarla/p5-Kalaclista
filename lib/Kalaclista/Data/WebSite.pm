use v5.38;
use builtin qw(true false);
use feature qw(class state);
no warnings qw(experimental);

class Kalaclista::Data::WebSite::Internal {
  use URI::Escape::XS qw(decodeURIComponentIDN);

  field $label : param;
  field $title : param;
  field $summary : param;
  field $href : param;

  field $cite = "";

  method label   { $label }
  method title   { $title }
  method summary { $summary }
  method href    { $href }

  method internal { true }
  method external { false }

  method cite {
    return $cite if $cite ne q{};

    $cite = decodeURIComponentIDN( $href->to_string );

    return $cite;
  }
}

class Kalaclista::Data::WebSite::External {
  use URI::Escape::XS qw(decodeURIComponentIDN);

  field $title : param;
  field $href : param;
  field $link : param;
  field $gone : param;

  field $cite = "";

  method title { $title }
  method href  { $href }
  method link  { $link }
  method gone  { $gone }

  method internal { false }
  method external { true }

  method cite {
    return $cite if $cite ne q{};

    $cite = decodeURIComponentIDN( $href->to_string );

    return $cite;
  }
}

package Kalaclista::Data::WebSite {
  use Carp qw(croak);

  sub new {
    my $class = shift;
    my $props = {@_};

    my $title   = delete $props->{'title'};
    my $summary = delete $props->{'summary'};
    my $href    = delete $props->{'href'};

    if ( exists $props->{'label'} && !exists $props->{'gone'} ) {
      my $label = delete $props->{'label'};
      return Kalaclista::Data::WebSite::Internal->new(
        label   => $label,
        title   => $title,
        summary => $summary,
        href    => $href,
      );
    }
    elsif ( !exists $props->{'label'} && exists $props->{'gone'} ) {
      my $link = delete $props->{'link'} // $href;
      my $gone = delete $props->{'gone'};
      return Kalaclista::Data::WebSite::External->new(
        title => $title,
        href  => $href,
        link  => $link,
        gone  => $gone,
      );
    }
    else {
      croak 'failed to detect website is internal or external';
    }
  }
}
