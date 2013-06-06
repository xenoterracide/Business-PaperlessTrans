package Business::PaperlessTrans::Request::AuthorizeCard;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.001000'; # VERSION

use Moose;
extends 'Business::PaperlessTrans::Request';

with qw(
	Business::PaperlessTrans::Request::Role::Authorization
);

sub _build_type {
	return 'AuthorizeCard';
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: AuthorizeCard Request

__END__

=pod

=head1 NAME

Business::PaperlessTrans::Request::AuthorizeCard - AuthorizeCard Request

=head1 VERSION

version 0.001000

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
