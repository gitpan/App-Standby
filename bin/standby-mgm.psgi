#!/usr/bin/perl
# ABSTRACT: App::Standby PSGI web app
# PODNAME: standby-mgm.psgi
use strict;
use warnings;

use lib '../lib';

use Plack::Builder;
use File::ShareDir;
use Try::Tiny;
use App::Standby::Frontend;

my $Frontend = App::Standby::Frontend::->new();
my $app = sub {
    my $env = shift;

    return $Frontend->run($env);
};

my $static_path = $Frontend->config()->get('App::Standby::Frontend::StaticPath', { Default => 'share/res', });
if(!$static_path || !-d $static_path) {
    my $dist_dir;
    try {
        $dist_dir = File::ShareDir::dist_dir('App-Standby');
    };
    if($dist_dir && -d $dist_dir) {
        $static_path = $dist_dir.'/res';
    }
}

builder {
    enable 'Plack::Middleware::Static',
        path => qr{/(img|js|css)/}, root => $static_path;
    $app;
};

__END__

=pod

=encoding utf-8

=head1 NAME

standby-mgm.psgi - App::Standby PSGI web app

=head1 AUTHOR

Dominik Schulz <dominik.schulz@gauner.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Dominik Schulz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
