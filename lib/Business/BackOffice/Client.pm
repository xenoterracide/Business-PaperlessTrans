package Business::BackOffice::Client;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use Class::Load 0.20 'load_class';
use Module::Load 'load';
use Data::Printer alias => 'Dumper';
use Carp;

use MooseX::Types::Path::Class qw( File Dir );

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub submit {
	my ( $self, $request ) = @_;

	my %request;
	if ( $request->type eq 'TestConnection' ) {
		%request = ( %{ $request->serialize });
	}
	else {
		%request = ( req => $request->serialize );
	}

	Dumper %request if $self->debug >= 1;

	my ( $answer, $trace ) = $self->_get_call( $request->type )->( %request );

	carp "REQUEST >\n"  . $trace->request->as_string  if $self->debug > 1;
	carp "RESPONSE <\n" . $trace->response->as_string if $self->debug > 1;

	Dumper $answer  if $self->debug >= 1;

	my $res = $answer->{parameters}{$request->type . 'Result'};

	my $res_c = 'Business::BackOffice::Response::' . $request->type;

	return load_class( $res_c )->new( $res );
}

sub _build_calls {
	my $self = shift;

	my %calls;
	foreach my $call ( qw( TestConnection AuthorizeCard ProcessCard ) ) {
		$calls{$call} = $self->_wsdl->compileClient( $call );
	}
	return \%calls;
}

sub _build_wsdl {
	my $self = shift;

	my $wsdl
		= XML::Compile::WSDL11->new(
			$self->_wsdl_file->stringify,
		);

	foreach my $xsd ( $self->_list_xsd_files ) {
		$wsdl->importDefinitions( $xsd->stringify );
	}

	return $wsdl;
}

sub _build_wsdl_file {
	load 'File::ShareDir::ProjectDistDir', 'dist_file', 'dist_dir';

	return load_class('Path::Class::File')->new(
		dist_file(
			'Business-OnlinePayment-BackOffice',
			'svc.paperlesstrans.wsdl'
		)
	);
}

sub _build_xsd_files {
	load 'File::ShareDir::ProjectDistDir', 'dist_file';

	my @xsd;
	foreach ( 0..6 ) {
		my $file
			= load_class('Path::Class::File')->new(
				dist_file(
					'Business-OnlinePayment-BackOffice',
					"svc.paperlesstrans.$_.xsd"
				)
			);

		push @xsd, $file;
	}
	return \@xsd;
}

has debug => (
	isa      => 'Int',
	is       => 'ro',
	lazy     => 1,
	default  => 0,
);

has _calls => (
	isa     => 'HashRef',
	traits  => ['Hash'],
	is      => 'rw',
	lazy    => 1,
	builder => '_build_calls',
	handles => {
		_get_call => 'get',
	},
);

has _wsdl => (
	isa     => 'XML::Compile::WSDL11',
	is      => 'ro',
	lazy    => 1,
	builder => '_build_wsdl'
);

has _wsdl_file => (
	isa     => File,
	lazy    => 1,
	is      => 'ro',
	builder => '_build_wsdl_file',
);

has _xsd_files => (
	isa     => 'ArrayRef[Path::Class::File]',
	traits  => ['Array'],
	lazy    => 1,
	is      => 'ro',
	builder => '_build_xsd_files',
	handles => {
		_list_xsd_files => 'elements',
	},
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: BackOffice Client object

=head1 DESCRIPTION

BackOffice is a secure and seamless bridge between your IT infrastructure and
the Paperless Transactions cloud. This service enables your organization to
connect directly and securely for processing credit card and ACH transactions.

=attr token

L<Business::BackOffice::RequestPart::AuthenticationToken>

=attr test

Set request to Test Mode when true
