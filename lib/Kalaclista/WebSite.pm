package Kalaclista::WebSite;

use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
  new => 1,
  rw  => [qw( fn title summary href gone lastmod lastupdate redirected )],
);

use HTTP::Tinyish;
use HTTP::Tinyish::Curl;

use Encode;
use Encode::Guess;
use Encode::Detect::Detector;

use HTML5::DOM;
use Time::Moment;
use URI::Escape qw( uri_unescape );
use URI;
use YAML::Tiny;

use Kalaclista::HyperScript qw(aside a h1 blockquote p cite text);

my $ua = 'Mozilla/5.0 (X11; Linux x86_64; rv:99.0) Gecko/20100101 Firefox/99.0';
my $client =
  HTTP::Tinyish->new( agent => $ua, timeout => 5, max_redirect => 3 );

my $parser = HTML5::DOM->new;

sub load {
  my $class = shift;
  my %args  = @_;

  my $title = delete $args{'title'} // q{};
  my $href  = delete $args{'href'}  // q{};
  my $src   = delete $args{'srcdir'};

  my $fn = _filename($href);

  if ( defined $src && $src->child($fn)->is_file ) {
    my $data = YAML::Tiny::Load( $src->child($fn)->slurp_utf8 );
    return $class->new( $data->%*, title => $title, href => $href, fn => $fn );
  }

  return $class->new( title => $title, href => $href, fn => $fn );
}

sub emit {
  my $self = shift;
  my $dir  = shift;

  my $fn   = $self->fn;
  my $file = $dir->child($fn);

  $file->parent->mkpath;

  my $fh = $file->openw_utf8;
  print $fh YAML::Tiny::Dump(
    {
      title      => $self->title   // q{},
      summary    => $self->summary // q{},
      href       => $self->href    // q{},
      lastmod    => int( $self->lastmod    // 0 ),
      lastupdate => int( $self->lastupdate // 0 ),
      redirected => int( $self->is_redirected ),
      gone       => int( $self->gone // 0 ),
    }
  );

  $fh->close;
}

sub _filename {
  my $href = shift;
  my $fn   = uri_unescape( URI->new( $href, 'https' )->path );
  utf8::decode($fn);

  $fn =~
s{[^\p{InHiragana}\p{InKatakana}\p{InCJKUnifiedIdeographs}a-zA-Z0-9\-_/]}{_}g;
  $fn =~ s{_+}{_}g;

  if ( $fn =~ m{/$} ) {
    $fn =~ s{/$}{};
  }

  if ( $fn eq q{} ) {
    $fn = "index";
  }

  return $fn . ".yaml";
}

sub fetch {
  my $self = shift;
  my $time = time;

  my $headers = {};
  if ( ( $self->lastmod // 0 ) != 0 ) {
    $headers->{'If-Modified-Since'} = _if_modified_since($time);
  }

  if ( defined( $self->lastupdate )
    && $self->lastupdate != 0
    && $time - $self->lastupdate < 60 * 60 * 24 * 14 )
  {
    return 0;
  }

  if ( defined $self->gone && $self->gone == 1 ) {
    $self->lastupdate($time);
    return 0;
  }

  my $res;

  local $@;
  eval { $res = $client->get( $self->href, { headers => $headers } ); };
  if ($@) {
    $self->gone(1);
    $self->lastupdate($time);
    return 1;
  }

  if ( !$res->{'success'} && $res->{'status'} =~ m{^(4|5)} ) {
    $self->gone(1);
    $self->lastupdate($time);
    return 0;
  }

  if ( $res->{'status'} != 304 ) {
    $self->lastmod($time);
  }

  $self->lastupdate($time);
  $self->redirected( $self->is_redirected );

  my $content = _decode_content($res);
  if ( $content ne q{} ) {
    $self->parse($content);
  }

  return 1;
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

sub is_redirected {
  my $self = shift;
  my $out =
    lc `curl -m 5 -s --head -X HEAD '@{[ $self->href ]}' | grep -i Location`;
  chomp($out);

  if ( $out =~ m{location} ) {
    return 1;
  }

  return 0;
}

sub parse {
  my $self = shift;
  my $html = shift;
  my $dom  = $parser->parse($html);

  my ( $title, $summary );

  for
    my $selector ( q<meta[property="og:title"]>, q<meta[name="twitter:title"]>,
    q<title> )
  {
    my $el = $dom->at($selector);
    if ( defined $el ) {
      if ( $selector ne q<title> ) {
        $title = $el->getAttribute('content');
      }
      else {
        $title = $el->textContent;
      }
    }

    if ( defined $title && $title ne q{} ) {
      $self->title($title);
      last;
    }
  }

  for my $selector (
    q<meta[property="og:description"]>,
    q<meta[name="twitter:description"]>,
    q<meta[name="description"]>
    )
  {
    my $el = $dom->at($selector);
    if ( defined $el ) {
      $summary = $el->getAttribute('content');
    }

    if ( defined $summary && $summary ne q{} ) {
      $self->summary($summary);
      last;
    }
  }

  return 1;
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

  if ( defined( $charset = ( $content =~ m{<?xml.+?encoding="([^"]+)"} )[0] ) )
  {
    goto DECODE;
  }

  if ( defined( $charset = ( $content =~ m{<?xml.+?encoding='([^']+)'} )[0] ) )
  {
    goto DECODE;
  }

  if (
    defined( my $charset = ( $content =~ m{<?xml.+?encoding=([^ ?]+)} )[0] ) )
  {
    goto DECODE;
  }

  # by content data
  if ( defined( $charset = Encode::Detect::Detector::detect($content) ) ) {
    goto DECODE;
  }

  if (
    defined(
      my $define = guess_encoding( $content, Encode->encodings(':all') )
    )
    )
  {
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

sub to_html {
  my $self = shift;
  return aside(
    { class => 'content__card--website' },
    a(
      { href => $self->href },
      [
        h1( { class => 'content__card--title' }, text( $self->title ) ),
        p( cite( text( uri_unescape( $self->href ) ) ) ),
        blockquote( p( text( $self->summary // $self->title ) ) )
      ]
    )
  );
}

1;
