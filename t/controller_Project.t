use strict;
use warnings;
use Test::More;

eval "use Test::WWW::Mechanize::Catalyst 'Gitweb'";
plan $@
    ? ( skip_all => 'Test::WWW::Mechanize::Catalyst required' )
    : ( tests => 2 );

ok( my $mech = Test::WWW::Mechanize::Catalyst->new, 'Created mech object' );

$mech->get_ok( 'http://localhost/project' );


