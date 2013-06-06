package Business::PaperlessTrans::Request::Role::Profile;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.001004'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::Common::String qw( NumericCode );

has profile_number => (
	remote_name => 'ProfileNumber',
	isa         => NumericCode,
	is          => 'ro',
);

1;
# ABSTRACT: Test Mode

__END__

=pod

=head1 NAME

Business::PaperlessTrans::Request::Role::Profile - Test Mode

=head1 VERSION

version 0.001004

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
