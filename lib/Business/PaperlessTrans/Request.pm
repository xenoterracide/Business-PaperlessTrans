package Business::PaperlessTrans::Request;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'MooseY::RemoteHelper::MessagePart';

use Class::Load 0.20 'load_class';

with qw(
	MooseX::RemoteHelper::CompositeSerialization
);

has type => (
	isa     => 'Str',
	is      => 'ro',
	lazy    => 1,
	builder => '_build_type',
);

has custom_fields => (
	remote_name => 'CustomFields',
	isa         => 'Business::PaperlessTrans::RequestPart::CustomFields',
	is          => 'ro',
	default     => sub {
		load_class('Business::PaperlessTrans::RequestPart::CustomFields')->new
	},
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: AuthorizeCard Request
