package Gitweb::Controller::Project;

use strict;
use warnings;
use Data::Page;
use base 'Catalyst::Controller::BindLex';

=head1 NAME

Gitweb::Controller::Project - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index 

=cut

sub project : Chained PathPart('project') CaptureArgs(1) {
    my ($self, $c, $project) = @_;

    my $project_name : Stashed = $project;
    my $head         : Stashed = 'master';
}

sub summary : Chained('project') Args(0) {
    my ($self, $c) = @_;
    my $project_name : Stashed;

    my $page  : Stashed = $c->request->param( 'page'  ) || 0;
    my $count : Stashed = $c->request->param( 'count' ) || 30;

    my $git = $c->model('Git');

    my $project : Stashed = $git->project_info($project_name);
    my $revs    : Stashed = $c->model('Git')->list_revs($project_name,
            skip  => $page * $count,
            count => $count,
    );
}

sub shortlog : Chained('project') Args(0) {
    my ($self, $c) = @_;
    my $project_name : Stashed;

    my $page  : Stashed = $c->request->param( 'page'  ) || 0;
    my $count : Stashed = $c->request->param( 'count' ) || 30;

    my $revs : Stashed = $c->model('Git')->list_revs($project_name,
            skip  => $page * $count,
            count => $count,
    );
}

sub log : Chained('project') Args(0) {
    my ($self, $c) = @_;
    my $project_name : Stashed;

    my $page  : Stashed = $c->request->param( 'page'  ) || 0;
    my $count : Stashed = $c->request->param( 'count' ) || 30;

    my $revs : Stashed = $c->model('Git')->list_revs($project_name,
            skip  => $page * $count,
            count => $count,
    );
}

sub snapshot : Chained('project') Args(0) {
    my ($self, $c) = @_;
    my $project_name : Stashed;
}

sub rev : Chained('project') CaptureArgs(1) {
    my ($self, $c, $rev_arg) = @_;

    my $rev : Stashed = $rev_arg;
}

sub commit : Chained('rev') Args(0) {
    my ($self, $c) = @_;
    my $rev : Stashed;
    my $project_name : Stashed;

    my $commit : Stashed = @{ $c->model('Git')->rev_info($project_name, $rev) || [] }[0];
}

sub commitdiff : Chained('rev') Args(0) {
    my ($self, $c) = @_;
    my $rev : Stashed;
}

sub commit_snapshot : Chained('rev') PathPart('snapshot') Args(0) {
    my ($self, $c) = @_;
    my $rev : Stashed;
}

=head1 AUTHOR

Florian Ragwitz

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
