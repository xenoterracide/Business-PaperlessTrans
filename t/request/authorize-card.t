use strict;
use warnings;
use Test::More;
use Test::Method;
use Class::Load 0.20 'load_class';
use Test::Requires::Env qw(
	PERL_BUSINESS_BACKOFFICE_USERNAME
	PERL_BUSINESS_BACKOFFICE_PASSWORD
);

my $req_prefix = 'Business::BackOffice::Request';
my $prefix     = $req_prefix . 'Part::';

my $address
	= new_ok( load_class( $prefix . 'Address' ) => [{
		street  => '400 E. Royal Lane #201',
		city    => 'Irving',
		state   => 'TX',
		zip     => '75039-2291',
		country => 'US',
	}]);

my $id
	= new_ok( load_class( $prefix . 'Identification' ) => [{
		id_type    => 1,
		state      => 'TX',
		number     => '12345678',
		address    => $address,
		expiration => {
			day   => 12,
			month => 12,
			year  => 2009,
		},
		date_of_birth => {
			day   => 12,
			month => 12,
			year  => 1965,
		},
	}]);

my $card
	= new_ok( load_class( $prefix . 'Card' ) => [{
		number          => '4012888888881881',
		security_code   => '999',
		name_on_account => 'John Doe and Associates',
		email_address   => 'JohnDoe@TestDomain.com',
		address         => $address,
		identification  => $id,
		expiration      => {
			month => '12',
			year  => '2015',
		},
	}]);

my $token
	= new_ok( load_class( $prefix . 'AuthenticationToken' ) => [{
		terminal_id  => $ENV{PERL_BUSINESS_BACKOFFICE_USERNAME},
		terminal_key => $ENV{PERL_BUSINESS_BACKOFFICE_PASSWORD},
	}]);

my $req
	= new_ok( load_class( $req_prefix . '::AuthorizeCard' ) => [{
		amount       => 9.65,
		currency     => 'USD',
		card         => $card,
		card_present => 0,
		test         => 1,
		token        => $token,
	}]);


my $client
	= new_ok( load_class('Business::BackOffice::Client') => [{
		debug => $ENV{PERL_BUSINESS_BACKOFFICE_DEBUG},
	}]);

my $res = $client->submit( $req );

isa_ok $res, 'Business::BackOffice::Response::AuthorizeCard';

done_testing;