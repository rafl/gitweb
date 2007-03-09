package Gitweb::View::Mason;

use strict;
use warnings;
use base 'Catalyst::View::Mason';

__PACKAGE__->config(
        comp_root => Gitweb->path_to(qw/root templates/)->stringify,
        default_escape_flags => 'h',
);

=head1 NAME

Gitweb::View::Mason - Mason View Component

=head1 SYNOPSIS

    Very simple to use

=head1 DESCRIPTION

Very nice component.

=head1 AUTHOR

Clever guy

=head1 LICENSE

This library is free software . You can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
