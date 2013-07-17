package Business::PaperlessTrans::RequestPart::Card;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;

extends 'MooseY::RemoteHelper::MessagePart';
with qw(
	MooseX::RemoteHelper::CompositeSerialization
	Business::PaperlessTrans::Role::Address
	Business::PaperlessTrans::Role::NameOnAccount
	Business::PaperlessTrans::Role::Identification
	Business::PaperlessTrans::Role::EmailAddress
);

use MooseX::Types::Common::String qw( NonEmptySimpleStr );
use MooseX::Types::CreditCard 0.002 qw(
	CardNumber
	CardExpiration
	CardSecurityCode
);

has number => (
	isa         => CardNumber,
	is          => 'ro',
	required    => 1,
	remote_name => 'CardNumber',
);

has security_code => (
    isa         => CardSecurityCode,
    remote_name => 'SecurityCode',
    predicate   => 'has_security_code',
    is          => 'ro',
);

has track_data => (
	isa         => NonEmptySimpleStr,
	is          => 'ro',
	remote_name => 'TrackData',
);

has expiration => (
	isa         => CardExpiration,
	is          => 'ro',
	required    => 1,
	coerce      => 1,
	handles     => [qw( month year )],
);

has _expiration_month => (
	isa         => 'Int',
	remote_name => 'ExpirationMonth',
	is          => 'ro',
	lazy        => 1,
	reader      => undef,
	writer      => undef,
	init_arg    => undef,
	default     => sub { shift->expiration->month },
);

has _expiration_year => (
	isa         => 'Int',
	remote_name => 'ExpirationYear',
	is          => 'ro',
	lazy        => 1,
	reader      => undef,
	writer      => undef,
	init_arg    => undef,
	default     => sub { shift->expiration->year },
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Card
