package Business::PaperlessTrans::Client;
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
use File::ShareDir::ProjectDistDir ':all', defaults => { pathclass => 1 };

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;


with 'MooseY::RemoteHelper::Role::Client';

sub submit {
	my ( $self, $request ) = @_;

	my %request = %{ $self->_finalize_request( $request ) };

	Dumper %request if $self->debug >= 1;

	my ( $answer, $trace ) = $self->_get_call( $request->type )->( %request );

	carp "REQUEST >\n"  . $trace->request->as_string  if $self->debug > 1;
	carp "RESPONSE <\n" . $trace->response->as_string if $self->debug > 1;

	Dumper $answer  if $self->debug >= 1;

	my $res = $answer->{parameters}{$request->type . 'Result'};

	my $res_c = 'Business::PaperlessTrans::Response::' . $request->type;

	return load_class( $res_c )->new( $res );
}

sub _finalize_request {
	my ( $self, $request ) = @_;

	my %request;
	if ( $request->type eq 'TestConnection' ) {
		%request = ( %{ $request->serialize },
			token => {
				TerminalID  => $self->user,
				TerminalKey => $self->pass,
			},
		);
	}
	else {
		%request = ( req => {
			%{ $request->serialize },
			Token => {
				TerminalID  => $self->user,
				TerminalKey => $self->pass,
			},
			TestMode => $self->test ? 'True' : 'False',
		});
	}

	return \%request;
}

sub _build_calls {
	my $self = shift;

	my @calls = qw( TestConnection AuthorizeCard ProcessCard ProcessACH );

	my %calls;
	foreach my $call ( @calls ) {
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
	return dist_file(
		'Business-OnlinePayment-PaperlessTrans',
		'svc.paperlesstrans.wsdl'
	);
}

sub _build_xsd_files {
	my @xsd;
	foreach ( 0..6 ) {
		my $file
			= dist_file(
				'Business-OnlinePayment-PaperlessTrans',
				"svc.paperlesstrans.$_.xsd"
			);

		push @xsd, $file;
	}
	return \@xsd;
}

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
# ABSTRACT: PaperlessTrans Client object

=head1 DESCRIPTION

PaperlessTrans is a secure and seamless bridge between your IT infrastructure and
the Paperless Transactions cloud. This service enables your organization to
connect directly and securely for processing credit card and ACH transactions.

=head1 WITH

uses the standard interface provided by:

L<MooseY::RemoteHelper::Role::Client>

=method submit

	my $response = $client->submit( $request );

=attr user

Terminal ID

=attr pass

Terminal Key

=attr debug

=attr test
