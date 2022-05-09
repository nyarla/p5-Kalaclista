#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Kalaclista::Application;
use Kalaclista::Config;

my $app = Kalaclista::Application->new;

$app->run(@ARGV);

=encoding utf-8

=head1 NAME

Kalaclista::Application - The static website generator for nyarla

=head1 SYNOPSIS

  # kalaclista.pl - configuration script for website
  $ kalaclista.pl -u 'http://nixos:1313' -a split-content

=head1 OPTIONS

=head2 --url,-u 

The baseURI of generate website

=head2 --action,-a 

The action name of running task.

=head2 --config,-c

The configuration file written by perl.

=head2 --threads,-t

The number of parallel threads.

=head1 AUTHOR

OKAMURA Naoki aka nyarla.

=cut
