package Business::PaperlessTrans::Response::Role::Authorization;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.001000'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;

has authorization => (
	remote_name => 'Authorization',
	isa         => 'Str',
	is          => 'ro',
);

1;
# ABSTRACT: Authorized Card Response

__END__

=pod

=head1 NAME

Business::PaperlessTrans::Response::Role::Authorization - Authorized Card Response

=head1 VERSION

version 0.001000

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
