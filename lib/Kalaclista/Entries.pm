package Kalaclista::Entries;

use v5.38;
use builtin qw(true);
no warnings qw(experimental);

use Kalaclista::Context;
use Kalaclista::Entry;
use Kalaclista::Files;

sub lookup {
  my $class   = shift;
  my $rootdir = shift;
  my %args    = @_;
  my @entries = Kalaclista::Files->find($rootdir);

  my $filter = $args{'filter'} //= sub { return true };
  my $sort   = $args{'sort'}   //= sub { $_[0]->path->path cmp $_[1]->path->path };
  my $fixup  = $args{'fixup'}  //= sub { return $_[0] };

  return [
    sort { $sort->( $a, $b ) }
    map  { my $e = Kalaclista::Entry->new( path => $_ ); $fixup->($e); $e }
    grep { $filter->($_) } @entries
  ];
}
