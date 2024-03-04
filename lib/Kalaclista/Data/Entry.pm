use v5.38;
use feature qw(class);
use builtin qw(false);
no warnings qw(experimental);

class Kalaclista::Data::Entry {
  field $title : param;
  field $summary : param;

  field $section : param;

  field $draft : param = false;
  field $date : param;
  field $lastmod : param;

  field $href : param;

  field $src : param  = "";
  field $dom : param  = undef;
  field $meta : param = {};

  method title   { $title }
  method summary { $summary }
  method section { $section }
  method draft   { $draft }
  method date    { $date }
  method lastmod { $lastmod }
  method href    { $href }
  method src     { $src }
  method dom     { $dom }
  method meta    { $meta }

  method updated { $self->lastmod // $self->date }

  method clone {
    my $class     = ref($self);
    my %overrides = @_;

    my %props = (
      title   => $title,
      summary => $summary,
      section => $section,
      draft   => $draft,
      date    => $date,
      lastmod => $lastmod,
      href    => $href,
      src     => $src,
      dom     => $dom,
    );

    my %meta = $meta->%*;
    if ( exists $overrides{'meta'} ) {
      my $override = delete $overrides{'meta'};
      $meta{$_} = $override->{$_} for keys $override->%*;
    }

    $props{'meta'} = {%meta};

    for my $prop ( keys %overrides ) {
      $props{$prop} = $overrides{$prop};
    }

    return $class->new(%props);
  }
}
