use v5.38;
use feature qw(state class);
no warnings qw(experimental);

use Encode               ();
use HTTP::Tinyish::Curl  ();
use HTML5::DOM           ();
use HTML5::DOM::Encoding ();

class Kalaclista::UserAgent::Response {
  field $status : param;
  field $reason : param;
  field $success : param;
  field $headers : param;
  field $url : param;
  field $content : param;
  field $protocol : param;

  field $decoded = undef;
  field $html    = undef;

  my $parser = HTML5::DOM->new;

  method status  { $status }
  method reason  { $reason }
  method success { $success }
  method headers { $headers }
  method content { $content }

  method decoded_content {
    return $decoded if defined $decoded;

    my $name;

    # in html
    if ( $headers->{'content-type'} =~ m{html}i ) {
      my $id = HTML5::DOM::Encoding->NOT_DETERMINED;

      # detect encoding from content
      for my $method (qw<detectByPrescanStream detectByCharset detectBomAndCut detect>) {
        my $func = HTML5::DOM::Encoding->can($method);
        $id = $func->($content);
        if ( $id != HTML5::DOM::Encoding->NOT_DETERMINED ) {
          last;
        }
      }

      # detect from content type
      if ( HTML5::DOM::Encoding->NOT_DETERMINED ) {
        my $fragment = qq{<meta http-equiv="content-type" content="@{[ $headers->{'content-type'} ]}">};
        $id = HTML5::DOM::Encoding::detectByPrescanStream($fragment);
      }

      # force use utf8
      $id   = HTML5::DOM::Encoding->UTF_8;
      $name = HTML5::DOM::Encoding::id2name($id);
    }
    elsif ( $headers->{'content-type'} =~ m{xml} ) {

      # detect from xml header
      $name = ( $content =~ m{encoding="([^"]+)"} )[0];
      if ( !$name ) {
        $name = ( $content =~ m{encoding='([^']+)'} )[0];
      }
    }

    if ( !$name ) {
      $name = 'UTF-8';
    }

    $decoded = Encode::decode( $name, $content );

    return $decoded;
  }

  method as_html {
    return $html if defined $html;

    $html = $parser->parse( $self->decoded_content );

    return $html;
  }
}

class Kalaclista::UserAgent {
  field $name : param;
  field $version : param;
  field $contact : param;
  field $timeout : param = 5;

  field $agent = undef;

  method agent {
    return $agent if defined $agent;

    HTTP::Tinyish::Curl->configure;
    $agent = HTTP::Tinyish::Curl->new(
      agent        => "${name}/${version} (+${contact})",
      timeout      => $timeout,
      max_redirect => 0,
    );

    return $agent;
  }

  method request {
    my ( $method, $href, $opts ) = @_;
    my $response = $self->agent->request( $method, $href, $opts );
    return Kalaclista::UserAgent::Response->new( $response->%* );
  }

  method get    { return $self->request( GET    => @_ ) }
  method head   { return $self->request( HEAD   => @_ ) }
  method post   { return $self->request( POST   => @_ ) }
  method put    { return $self->request( PUT    => @_ ) }
  method delete { return $self->request( DELETE => @_ ) }
  method patch  { return $self->request( PATCH  => @_ ) }
};

1;
