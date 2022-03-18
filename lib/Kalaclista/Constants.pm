package Kalaclista::Constants;

use strict;
use warnings;

use URI;
use Exporter 'import';

our $PRODUCTION =
  defined( $ENV{'ENV'} ) && $ENV{'ENV'} eq "production";

our @EXPORT_OK = qw( linkify );

sub linkify {
  my ( $link, $env ) = @_;
  $env //= $PRODUCTION;

  my $domain = $env ? "the.kalaclista.com" : "nixos:1313";
  my $proto  = $env ? "https"              : "http";

  my $uri = URI->new("");
  $uri->scheme($proto);
  $uri->host_port($domain);
  $uri->path($link);

  return $uri;
}

1;
