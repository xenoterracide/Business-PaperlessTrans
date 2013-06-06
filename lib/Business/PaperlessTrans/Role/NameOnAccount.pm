package Business::PaperlessTrans::Role::NameOnAccount;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.001004'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::Common::String qw( NonEmptySimpleStr );

has name_on_account => (
	remote_name => 'NameOnAccount',
	isa         => NonEmptySimpleStr,
	is          => 'ro',
	required    => 1,
);

1;
# ABSTRACT: name associated with the account

__END__

=pod

=head1 NAME

Business::PaperlessTrans::Role::NameOnAccount - name associated with the account

=head1 VERSION

version 0.001004

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
