package Kalaclista::UserAgent;

use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
  new => 1,
  rw  => [qw(agent)],
  ro  => [qw(ua)],
);

use HTTP::Tinyish;

use Encode;
use Encode::Guess;
use Encode::Detect::Detector;

use Time::Moment;

use YAML::XS;
use Carp qw(confess);
use Path::Tiny;

sub client {
  my $self = shift;

  if ( !defined $self->ua ) {
    $self->agent(
      HTTP::Tinyish->new(
        agent        => $self->ua,
        timeout      => 10,
        max_redirect => 3,
      )
    );
  }

  return $self->agent;
}

sub fetch {
  my $self = shift;
  my $href = shift;
  my $file = shift;

  my $data = {};

  if ( $file->is_file ) {
    $data = YAML::XS::Load( $file->slurp_utf8 );
  }

  my %headers = ();
  my $time    = time;

  # Skip if last updated less than 2 week
  if ( ( $data->{'updated_at'} // 0 ) != 0
    && ( $time - $data->{'updated_at'} ) <= 60 * 60 * 24 * 14 ) {
    return q{};
  }

  # Skip if page is gone
  # if ( defined( $data->{'gone'} ) && $data->{'gone'} == 1 ) {
  #   return q{};
  # }

  if ( ( $data->{'lastmod'} // 0 ) != 0 ) {
    $headers{'Modified-Since'} = _if_modified_since($time);
  }

  my $res;
  local $@;
  eval { $res = $self->client->get( $href => { headers => \%headers } ); };

  if ($@) {
    $data->{'gone'}       = 1;
    $data->{'updated_at'} = $time;

    goto EMIT;
  }

  if ( !$res->{'success'} && $res->{'status'} =~ m{^(?:4|5)} ) {
    $data->{'gone'}       = 1;
    $data->{'updated_at'} = $time;

    goto EMIT;
  }

  $data->{'lastmod'}      = $time;
  $data->{'updated_at'}   = $time;
  $data->{'has_redirect'} = _has_redirect($href);

EMIT:
  $file->spew_utf8( YAML::XS::Dump($data) );

  return _decode_content($res);
}

sub _if_modified_since {
  my $epoch   = shift;
  my $time    = Time::Moment->from_epoch($epoch);
  my @dayweek = qw(Mon Tue Wed Thu Fri Sat Sun);
  my @month   = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

  my $out = join q{ },
      (
        $dayweek[ $time->day_of_week - 1 ] . ",",
        $time->strftime("%d"),
        $month[ $time->month - 1 ],
        $time->strftime('%Y %H:%M:%S'), "GMT"
      );

  return $out;
}

sub _has_redirect {
  my $href = shift;
  my $out  = lc `curl -m 5 -s --head -X GET '@{[ $href ]}' | grep -i Location`;
  chomp($out);

  if ( $out =~ m{location} ) {
    return 1;
  }

  return 0;
}

sub _fix_encoding {
  my $name = shift;

  if ( $name =~ m{shift.*?jis}i ) {
    return 'cp932';
  }

  if ( $name =~ m{sjis}i ) {
    return 'cp932';
  }

  if ( $name =~ m{euc-jp}i ) {
    return 'euc-jp';
  }

  if ( $name =~ m{utf.*?8}i ) {
    return 'utf8';
  }

  if ( $name =~ m{us-ascii}i ) {
    return 'iso-8859-1';
  }

  if ( $name =~ m{ISO-*}i ) {
    return lc $name;
  }

  return $name;
}

sub _decode_content {
  my ($res) = @_;

  my $content = $res->{'content'};
  my $charset = q{};

  if ( !defined $content || $content eq q{} ) {
    return "";
  }

  my $content_type = $res->{'headers'}->{'Content-Type'};
  $content_type //= $res->{'headers'}->{'content-type'};
  $content_type //= q{};

  # by header
  if ( defined( $charset = ( $content_type =~ m{charset=([^ ;]+)} )[0] ) ) {
    goto DECODE;
  }

  # by content
  if ( defined( $charset = ( $content =~ m{<meta.+?charset="([^"]+)"} )[0] ) ) {
    goto DECODE;
  }

  if ( defined( $charset = ( $content =~ m{<meta.+?charset='([^']+)'} )[0] ) ) {
    goto DECODE;
  }

  if ( defined( $charset = ( $content =~ m{<meta.+?charset=([^ ;>]+)} )[0] ) ) {
    goto DECODE;
  }

  if ( defined( $charset = ( $content =~ m{<?xml.+?encoding="([^"]+)"} )[0] ) ) {
    goto DECODE;
  }

  if ( defined( $charset = ( $content =~ m{<?xml.+?encoding='([^']+)'} )[0] ) ) {
    goto DECODE;
  }

  if ( defined( my $charset = ( $content =~ m{<?xml.+?encoding=([^ ?]+)} )[0] ) ) {
    goto DECODE;
  }

  # by content data
  if ( defined( $charset = Encode::Detect::Detector::detect($content) ) ) {
    goto DECODE;
  }

  if ( defined( my $define = guess_encoding( $content, Encode->encodings(':all') ) ) ) {
    $charset = $define->name;
    goto DECODE;
  }

DECODE:

  if ( $charset eq q{} ) {
    $charset = "utf8";
  }

  $charset = _fix_encoding($charset);
  my $decoder = Encode::find_encoding($charset);

  my $err = 0;
  if ( !defined $decoder ) {
    $decoder = Encode::find_encoding('utf8');
  }

  return $decoder->decode($content);
}

1;
