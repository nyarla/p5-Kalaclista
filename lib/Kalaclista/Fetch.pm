package Kalaclista::Fetch;

use strict;
use warnings;
use utf8;

use HTTP::Tinyish;
use HTML5::DOM;

use Encode;
use Encode::Guess;
use Encode::Detect::Detector;

use Time::Moment;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( datadir agent timeout max_redirect  )],
);

use Kalaclista::WebSite;

my $parser = HTML5::DOM->new();

sub client {
  my $self = shift;

  if ( exists $self->{'client'} && defined( $self->{'client'} ) ) {
    return $self->{'client'};
  }

  $self->{'client'} = HTTP::Tinyish->new(
    agent        => $self->agent,
    timeout      => $self->timeout,
    max_redirect => $self->max_redirect,
  );

  return $self->{'client'};
}

sub fetch {
  my $self = shift;
  my $href = shift;

  my $data = Kalaclista::WebSite->load( $href, $self->datadir );

  if ( defined( $data->is_ignore ) && $data->is_ignore ) {
    return $data;
  }

  if ( defined( $data->is_gone ) && $data->is_gone ) {
    return $data;
  }

  my $now = time;
  my %headers;

  if ( ( $data->updated_at // 0 ) != 0 ) {
    $headers{'Modified-Since'} = _if_modified_since($now);
  }

  $data->updated_at($now);

  if ( _has_redirect($href) ) {
    $data->has_redirect(1);

    my $new = _get_location( $href, $self->max_redirect );
    if ( $new eq q{} ) {
      $data->is_gone(1);
      return $data;
    }

    $href = $new;
    $data->href($new);
  }

  my $res;
  local $@;
  eval { $res = $self->client->get( $href => { headers => \%headers } ); };

  if ($@) {
    $data->is_gone(1);
    $data->status(599);
    return $data;
  }

  $data->status( $res->{'status'} );

  if ( !$res->{'success'} ) {
    if ( $res->{'status'} =~ m{^(?:4|599)} ) {
      $data->is_gone(1);
    }

    return $data;
  }

  if ( $res->{'status'} == 304 ) {
    return $data;
  }

  my $content = _decode_content($res);
  my $parsed  = _parse_content($content);

  $data->title( $parsed->{'title'} );
  $data->summary( $parsed->{'summary'} );

  return $data;
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

sub _get_location {
  my $href  = shift;
  my $redir = shift;

  my $link = q{};

  for ( 0 .. $redir ) {
    my $out = `curl -w "%{redirect_url}" -s -o /dev/null '${href}'`;
    chomp($out);

    if ( $out eq q{} ) {
      $link = $href;
      last;
    }

    $href = $out;
  }

  return $link;
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
    if ( ref $define ) {
      $charset = $define->name;
    }
    goto DECODE;
  }

DECODE:

  if ( !defined $charset || $charset eq q{} ) {
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

sub _parse_content {
  my $content = shift;

  my $dom   = $parser->parse($content);
  my $title = _get_content(
    $dom,
    [ 'attr', 'meta[property="og:title"]',  'content' ],
    [ 'attr', 'meta[name="twitter:title"]', 'content' ],
    [ 'elm',  'title' ],
  );

  my $summary = _get_content(
    $dom,
    [ 'attr', 'meta[property="og:description"]',  'content' ],
    [ 'attr', 'meta[name="twitter:description"]', 'content' ],
    [ 'attr', 'meta[name="description"]',         'content' ],
  );

  return {
    title   => $title,
    summary => $summary,
  };
}

sub _get_content {
  my $dom   = shift;
  my @tasks = shift;

  for my $task (@tasks) {
    if ( $task->[0] eq 'attr' ) {
      my $el = $dom->at( $task->[1] );
      if ( defined $el ) {
        return $el->getAttribute( $task->[2] );
      }
    }

    if ( $task->[0] eq 'elm' ) {
      my $el = $dom->at( $task->[1] );
      if ( defined $el ) {
        return $el->textContent;
      }
    }
  }

  return q{};
}

1;
