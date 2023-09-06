use v5.38;
use feature qw(class);
no warnings qw(experimental);

class Kalaclista::Data::Amazon {
  field $title : param;
  field $link : param;
  field $image : param;

  method title {
    return $title;
  }

  method link {
    return $link;
  }

  method image {
    return $image;
  }
}
