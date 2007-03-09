use strict;
use warnings;
use Test::More tests => 12;

BEGIN { use_ok 'Gitweb::Model::Git' }

my $repo = 'repo1';

my $m = Gitweb::Model::Git->new;
isa_ok($m, 'Gitweb::Model::Git');

like($m->get_head_hash($repo), qr/^([0-9a-fA-F]{40})$/, 'get_head_hash');

{
    my @tree = $m->list_tree($repo, '3bc0634310b9c62222bb0e724c11ffdfb297b4ac');

    is(scalar @tree, 1);
    is_deeply($tree[0], {
            mode => oct 100644,
            type => 'blob',
            object => '257cc5642cb1a054f08cc83f2d943e56fd3ebe99',
            file => 'file1'
    });

    is($m->get_object_mode_string($tree[0]), '-rw-r--r--');
}

is($m->get_object_type($repo, '729a7c3f6ba5453b42d16a43692205f67fb23bc1'), 'tree');
is($m->get_object_type($repo, '257cc5642cb1a054f08cc83f2d943e56fd3ebe99'), 'blob');
is($m->get_object_type($repo, '5716ca5987cbf97d6bb54920bea6adde242d87e6'), 'blob');

is($m->cat_file($repo, '257cc5642cb1a054f08cc83f2d943e56fd3ebe99'), "foo\n");
is($m->cat_file($repo, '5716ca5987cbf97d6bb54920bea6adde242d87e6'), "bar\n");

is($m->diff($repo, '3bc0634310b9c62222bb0e724c11ffdfb297b4ac', '3f7567c7bdf7e7ebf410926493b92d398333116e'), <<EOD);
diff --git a/file1 b/file1
index 257cc56..5716ca5 100644
--- a/file1
+++ b/file1
@@ -1 +1 @@
-foo
+bar
EOD

Data::Dump::dump $m->list_revs($repo);
