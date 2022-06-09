package Kalaclista::Template;

use strict;
use warnings;
use utf8;

use Exporter 'import';

our @EXPORT = qw(load);

use Path::Tiny;

sub load {
  my $ns   = shift;
  my $path = shift;

  local $@;
  my $template = eval qq{
  package Kalaclista::Template::_${ns};

  use strict;
  use warnings;
  use utf8;

  use Kalaclista::HyperScript;
  use Kalaclista::HyperScript::HTMLUtils;
  use Kalaclista::HyperStyle;
  use Kalaclista::Template;

  @{[ path($path)->slurp_utf8 ]}
};

  if ($@) {
    my $err = $@;
    return $err;
  }

  return $template;
}

1;
