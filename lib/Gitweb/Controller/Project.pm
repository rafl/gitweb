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
    my $heads   : Stashed = $git->get_heads($project_name);
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

    my $rev : Stashed = $c->model('Git')->get_head_hash($project_name);
    $c->detach('commit_snapshot');
}

sub head : Chained('project') CaptureArgs(1) {
    my ($self, $c, $head_arg) = @_;

    my $head : Stashed = $head_arg;
}

sub head_shortlog : Chained('head') PathPart('shortlog') Args(0) {
    my ($self, $c) = @_;

    my $head         : Stashed;
    my $project_name : Stashed;

    my $template : Stashed = '/project/shortlog';

    my $page  : Stashed = $c->request->param( 'page'  ) || 0;
    my $count : Stashed = $c->request->param( 'count' ) || 30;

    my $revs : Stashed = $c->model('Git')->list_revs($project_name,
            rev   => $head,
            skip  => $page * $count,
            count => $count,
    );
}

sub head_log : Chained('head') PathPart('log') Args(0) {
    my ($self, $c) = @_;

    my $head         : Stashed;
    my $project_name : Stashed;

    my $template : Stashed = '/project/log';

    my $page  : Stashed = $c->request->param( 'page'  ) || 0;
    my $count : Stashed = $c->request->param( 'count' ) || 30;

    my $revs : Stashed = $c->model('Git')->list_revs($project_name,
            rev   => $head,
            skip  => $page * $count,
            count => $count,
    );
}

sub head_summary : Chained('head') PathPart('summary') Args(0) {
    my ($self, $c) = @_;

    my $head         : Stashed;
    my $project_name : Stashed;

    my $template : Stashed = '/project/summary';

    my $page  : Stashed = $c->request->param( 'page'  ) || 0;
    my $count : Stashed = $c->request->param( 'count' ) || 30;

    my $git = $c->model('Git');

    my $project : Stashed = $git->project_info($project_name);
    my $heads   : Stashed = $git->get_heads($project_name);
    my $revs    : Stashed = $c->model('Git')->list_revs($project_name,
            rev   => $head,
            skip  => $page * $count,
            count => $count,
    );
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
    my $project_name : Stashed;

    $c->response->header('Content-Type'        => 'application/x-tar');
    $c->response->header('Content-Disposition' => "inline; filename=${project_name}_${rev}.tar");

    $c->response->body( $c->model('Git')->archive($project_name, $rev) );
}

=head1 AUTHOR

Florian Ragwitz

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
