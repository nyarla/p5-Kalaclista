#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Kalaclista::Directory;
use Kalaclista::Sequential::Files;
use Kalaclista::Content;
use Kalaclista::WebSite;

use Parallel::Fork::BossWorkerAsync;
use Path::Tiny;
use URI;

my $ua = 'Mozilla/5.0 (X11; Linux x86_64; rv:98.0) Gecko/20100101 Firefox/98.0';

sub extract {
  my $file    = shift;
  my $content = Kalaclista::Content->new( text => $file->slurp_utf8 );
  my $dom     = $content->dom;

  my @out = ();
  for my $node ( $dom->find('ul > li:only-child > a:only-child')->@* ) {
    if ( $node->parent->firstChild->isSameNode($node) ) {
      my $href  = $node->getAttribute('href');
      my $title = $node->textContent;

      push @out,
        +{
        title  => $title,
        href   => $href,
        domain => URI->new( $href, 'https' )->host,
        };
    }
  }

  return @out;
}

sub worker {
  eval {
    my ( $domain, $websites, $dest ) = $_[0]->@*;

    my $max = $websites->@*;
    my $idx = 0;
    for my $data ( $websites->@* ) {
      $idx++;

      my $website = Kalaclista::WebSite->load(
        title  => $data->{'title'},
        href   => $data->{'href'},
        outdir => $dest->child($domain),
      );

      if ( $website->fetch ) {
        print "Fetch: ${domain}: ${idx} (${max}): @{[ $website->href ]}\n";
        $website->emit;
        sleep( 3 + rand(3) );
        next;
      }

      $website->emit;
      print "Skip: ${domain}: ${idx} (${max}): @{[ $website->href ]}\n";
    }

    return { domain => $domain };
  };
}

sub main {
  my $src     = path(shift)->realpath->stringify;
  my $dest    = path(shift);
  my $threads = shift;

  my $domains = {};
  my $loader  = Kalaclista::Sequential::Files->new(
    process => sub {
      my ( $processor, $file ) = @_;
      return extract($file);
    },
    result => sub {
      my ( $processor, @results ) = @_;
      for my $website (@results) {
        unless ( defined $website->{'domain'}
          && defined $website->{'title'}
          && defined $website->{'href'} )
        {
          next;
        }

        $domains->{ $website->{'domain'} } ||= [];
        push $domains->{ $website->{'domain'} }->@*,
          +{
          title => $website->{'title'},
          href  => $website->{'href'},
          };
      }
    },
  );

  $loader->run( $src, "**", "*.md" );

  my $bw = Parallel::Fork::BossWorkerAsync->new(
    work_handler => \&worker,
    worker_count => $threads,
  );

  for my $domain ( sort keys $domains->%* ) {
    $bw->add_work( [ $domain, $domains->{$domain}, $dest ] );
  }

  while ( $bw->pending ) {
    my $ref = $bw->get_result;
    if ( $ref->{'ERROR'} ) {
      print "Err: " . $ref->{'ERROR'};
    }
    else {
      print "Done: " . $ref->{'domain'} . "\n";
    }
  }

  $bw->shut_down();
}

main(@ARGV);
