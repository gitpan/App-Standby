package App::Standby;
{
  $App::Standby::VERSION = '0.01';
}
BEGIN {
  $App::Standby::AUTHORITY = 'cpan:TEX';
}
# ABSTRACT: Managing on-call rotation and notification queues

use 5.010_000;
use mro 'c3';
use feature ':5.10';

use Moose;
use namespace::autoclean;

# use IO::Handle;
# use autodie;
# use MooseX::Params::Validate;
# use Carp;
# use English qw( -no_match_vars );
# use Try::Tiny;

use Log::Tree;

# extends ...
# has ...
has 'dbh' => (
    'is'    => 'rw',
    'isa'   => 'App::Standby::DB',
    'required' => 1,
);

has 'logger' => (
    'is'    => 'rw',
    'isa'   => 'Log::Tree',
    'lazy'  => 1,
    'builder' => '_init_logger',
);

# with ...
# initializers ...
sub _init_logger {
    my $self = shift;

    my $Logger = Log::Tree::->new('standby-mgm');

    return $Logger;
}

# your code here ...
sub _config_values {
    my $self = shift;
    my $key = shift;
    my $group_id = shift;

    my @args = ();
    my $sql = 'SELECT `value` FROM config WHERE `key` = ?';
    push(@args,$key);
    if($group_id) {
        $sql .= ' AND group_id = ?';
        push(@args,$group_id);
    }
    my $sth = $self->dbh()->prepare($sql);
    $sth->execute(@args);

    my @values = ();

    while(my $value = $sth->fetchrow_array()) {
        push(@values,$value);
    }

    $sth->finish();

    return \@values;
}

sub _load_class {
    my $self = shift;
    my $classname  = shift;

    # String eval is bad. Always. Except for require ;)
    ## no critic (ProhibitStringyEval)
    my $ok = eval "require $classname;";
    ## use critic
    if ($@) {
        return $@;
    } else {
        return $classname;
    }
}


sub get_groups {
    my $self = shift;

    my $sql = 'SELECT id,name FROM groups';
    my $sth = $self->dbh()->prepare($sql);

    my %grps = ();
    $sth->execute();
    while(my ($id,$name) = $sth->fetchrow_array()) {
        $grps{$id} = $name;
    }

    $sth->finish();

    return \%grps;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding utf-8

=head1 NAME

App::Standby - Managing on-call rotation and notification queues

=head1 METHODS

=head2 get_groups

Returns a list of all groups.

=head1 NAME

App::Standby - Baseclass

=head1 AUTHOR

Dominik Schulz <dominik.schulz@gauner.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Dominik Schulz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
