package Gitweb::Controller::Projects;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

=head1 NAME

Gitweb::Controller::Projects - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 index 

=cut

sub process : Private {
    my ($self, $c) = @_;

    $c->detach('index');
}

sub index : Private {
    my ($self, $c) = @_;

    my $template : Stashed = 'projects/index';
    my $projects : Stashed = $c->model('Git')->list_projects;
}

=head1 AUTHOR

Florian Ragwitz,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
