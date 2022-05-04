package Kalaclista::Application;

use strict;
use warnings;

our $VERSION = "v0.0.1";

use Getopt::Long
  qw( :config posix_default no_ignore_case bundling auto_help auto_version );
use Pod::Usage qw( pod2usage );
use Module::Load qw(load);
use URI;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( config )],
);

sub action {
  my ( $self, $action, $baseURI ) = @_;

  my $module = join q{}, ( map { ucfirst $_ } ( split qr{-}, $action ) );
  $module = "Kalaclista::Actions::${module}";

  local $@;
  eval { load $module; };

  if ($@) {
    print STDERR "failed to load action module: $module: $@\n";
    exit 1;
  }

  return $module->action($self);
}

sub run {
  my $self = shift;
  local @ARGV = @_;

  my $baseURI = q{};
  my $action  = q{};

  GetOptions(
    "url|u=s"    => \$baseURI,
    "action|a=s" => \$action,
    "version|v"  => sub {
      print "Kalaclista::Application - ${VERSION}", "\n";
      exit 0;
    },
    "help|h" => sub { pod2usage( -exitval => 1, -verbose => 1 ); },
  ) or pod2usage( -exitval => 1, -verbose => 1 );

  $self->config->baseURI( URI->new($baseURI) );
  return $self->action($action);
}

1;
