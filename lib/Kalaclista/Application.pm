package Kalaclista::Application;

use strict;
use warnings;

our $VERSION = "v0.0.1";

use Getopt::Long qw( :config posix_default no_ignore_case bundling );
use Pod::Usage qw( pod2usage );
use Module::Load qw(load);
use URI::Fast;

use Class::Accessor::Lite ( new => 1, rw => [qw(context)] );

use Kalaclista::Context;

sub action {
  my ( $self, $action ) = @_;

  my $module = join q{}, ( map { ucfirst $_ } ( split qr{-}, $action ) );
  $module = "Kalaclista::Actions::${module}";

  local $@;
  eval { load $module; };

  if ($@) {
    print STDERR "failed to load action module: $module: $@\n";
    exit 1;
  }

  return $module->action( $self->context );
}

sub run {
  my $self = shift;
  local @ARGV = @_;

  my $baseURI = q{};
  my $action  = q{};
  my $config  = q{};
  my $threads = q{};

  GetOptions(
    "url|u=s"     => \$baseURI,
    "action|a=s"  => \$action,
    "config|c=s"  => \$config,
    "threads|t=i" => \$threads,
    "version|v"   => sub {
      print "Kalaclista::Application - ${VERSION}", "\n";
      exit 0;
    },
    "help|h" => sub { pod2usage( -exitval => 1, -verbose => 1 ); },
  ) or pod2usage( -exitval => 1, -verbose => 1 );

  if ( $baseURI eq {} || $action eq q{} || $config eq q{} ) {
    pod2usage( -exitval => 1, -verbose => 1 );
  }

  if ( !-e $config ) {
    print STDERR "configuraton file is not found: ${config}\n";
    exit 1;
  }

  my $settings = do $config;
  if ($@) {
    print STDERR "failed to eval configiration file: ${config}: ${@}\n";
    exit 1;
  }

  $self->context(
    Kalaclista::Context->instance(
      $settings->%*,
      baseURI => URI::Fast->new($baseURI),
      threads => $threads,
    )
  );

  $ENV{'URL'} = $baseURI;

  return $self->action($action);
}

1;
