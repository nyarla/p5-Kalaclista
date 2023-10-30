use v5.38;
use feature qw(class);
no warnings qw(experimental);

use Kalaclista::Data::WebSite;

class Kalaclista::Data::Page::Breadcrumb {
  field $tree : param = [];

  method push {
    my $website = Kalaclista::Data::WebSite->new(@_);
    push $tree->@*, $website;
  }

  method index {
    return $tree->[shift];
  }

  method length {
    return scalar( $tree->@* );
  }
}

class Kalaclista::Data::Page {
  field $title : param   = q{};
  field $summary : param = q{};
  field $section : param = q{};
  field $kind : param    = q{};
  field $href : param    = undef;
  field $entries : param = [];
  field $breadcrumb      = Kalaclista::Data::Page::Breadcrumb->new;
  field $vars : param    = {};

  method title      { return $title }
  method summary    { return $summary }
  method section    { return $section }
  method kind       { return $kind }
  method href       { return $href }
  method entries    { return $entries }
  method breadcrumb { return $breadcrumb }
  method vars       { return $vars }
}
