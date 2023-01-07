use strict;
use warnings;
use utf8;

package Kalaclista::Template;

use feature qw(state);

use Exporter::Lite;

our @EXPORT = qw(load);

use Path::Tiny;
use Module::Load ();

use Kalaclista::Constants;

sub className {
  my ( $klass, $dir ) = @_;
  state $results ||= {};

  if ( exists $results->{$klass} ) {
    return $results->{$klass};
  }

  my $class = $klass;

  $class =~ s{^$dir/|\.pl$|[^a-zA-Z0-9/]+}{}g;
  $class =~ s{/[0-9]+}{/}g;
  $class =~ s{(?:^|/)([a-z])}{'::' . uc($1)}eg;

  $results->{$klass} = $class;

  return $class;
}

sub load {
  my $template = shift;
  state $renderers ||= {};

  if ( $template !~ m{/} ) {
    if ( exists $renderers->{$template} ) {
      return $renderers->{$template};
    }

    Module::Load::load($template);
    my $renderer = $template->can('render');

    $renderers->{$template} = $renderer;

    return $renderer;
  }

  my $dir   = Kalaclista::Constaints->rootdir->child('template')->path;
  my $path  = $template;
  my $class = 'Kalaclista::Template::Script' . className( $path, $dir );

  if ( exists $renderers->{$class} ) {
    return $renderers->{$class};
  }

  my $renderer = sub {

    package Kalaclista::Template::Script;

    return Kalaclista::Template::Script->render( $class, $dir, $path, @_ );
  };

  $renderers->{$class} = $renderer;

  return $renderer;
}

package Kalaclista::Template::Script;

use YAML::XS;
use URI::Escape qw(uri_unescape);

use Text::HyperScript;
use Text::HyperScript::HTML5;

use Kalaclista::HyperScript;

our $dir;

{
  no strict 'refs';
  *{ __PACKAGE__ . '::load' } = \&Kalaclista::Template::load;
  use strict 'refs';
}

sub href {
  my ( $path, $baseURI ) = @_;
  my $link = $baseURI->clone;
  $link->path($path);
  return $link->as_string;
}

sub expand {
  my ( $tmpl, @args ) = @_;
  return load("${dir}/${tmpl}")->(@args);
}

sub className {
  my ( $block, $element, $modifier ) = @_;

  if ( defined $element && $element ne q{} ) {
    $block .= '__' . $element;
  }

  if ( defined $modifier && $modifier ne q{} ) {
    $block .= '--' . $modifier;
  }

  return ( class => $block );
}

sub date {
  return ( split qr{T}, $_[0] )[0];
}

sub render {
  state $renderers ||= {};
  my ( $class, $name, $rootdir, $path, @args ) = @_;

  local $dir = $rootdir;

  if ( exists $renderers->{$name} ) {
    return $renderers->{$name}->(@args);
  }

  my $renderer = do $path;
  $renderers->{$name} = $renderer;

  return $renderers->{$name}->(@args);
}

package Kalaclista::Template;

1;
