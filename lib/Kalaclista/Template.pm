package Kalaclista::Template;

use strict;
use warnings;
use utf8;

use Exporter 'import';

our @EXPORT = qw(load);

use Path::Tiny;
use Kalaclista::Directory;

sub className {
  my $dir   = Kalaclista::Directory->instance->templates_dir->stringify;
  my $class = shift;

  $class =~ s{$dir/}{};
  $class =~ s{\.pl$}{};
  $class =~ s{[^a-zA-Z0-9/]+}{}g;
  $class =~ s{/[0-9]+}{/}g;
  $class =~ s{(?:/)([a-z])}{'::' . uc($1)}eg;
  $class =~ s{^([a-z])}{uc($1)}e;

  return $class;
}

sub load {
  my $dir   = Kalaclista::Directory->instance->templates_dir->stringify;
  my $path  = shift;
  my $class = className($path);

  local $@;
  my $template = eval qq{
  package Kalaclista::Template::_${class};

  use strict;
  use warnings;
  use utf8;

  use YAML::Tiny;
  use URI::Escape qw(uri_unescape);
  
  use Kalaclista::HyperScript;
  use Kalaclista::HyperScript::More;
  use Kalaclista::HyperStyle;
  use Kalaclista::Template;

  no warnings 'redefine';

  sub href {
    my ( \$path, \$baseURI ) = \@_;
    my \$link = \$baseURI->clone;
    \$link->path(\$_[0]);
    return \$link->as_string;
  }

  sub expand {
    my ( \$tmpl, \@args ) = \@_;
    return load("${dir}/\$tmpl")->( \@args );
  }

  sub className {
    my ( \$block, \$element, \$modifier ) = \@_;

    if ( defined \$element && \$element ne q{} ) {
      \$block .= '__' . \$element;
    }

    if (defined \$modifier && \$modifier ne q{}) {
      \$block .= '--' . \$modifier;
    }

    return ( class => \$block );
  }

  sub date {
    return (split qr{T}, \$_[0])[0];
  }

  use warnings 'redefine';
  
  @{[ path($path)->slurp_utf8 ]}
};

  if ($@) {
    my $err = $@;
    return sub { return $err };
  }

  return $template;
}

1;
