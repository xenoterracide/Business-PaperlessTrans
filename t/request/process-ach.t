use strict;
use warnings;
use Test::More;
use Test::Method;
use Class::Load 0.20 'load_class';
use Test::Requires::Env qw(
	PERL_BUSINESS_BACKOFFICE_USERNAME
	PERL_BUSINESS_BACKOFFICE_PASSWORD
);

my $req_prefix = 'Business::PaperlessTrans::Request';
my $prefix     = $req_prefix . 'Part::';

my $token
	= new_ok( load_class( $prefix . 'AuthenticationToken' ) => [{
		terminal_id  => $ENV{PERL_BUSINESS_BACKOFFICE_USERNAME},
		terminal_key => $ENV{PERL_BUSINESS_BACKOFFICE_PASSWORD},
	}]);

my $client
	= new_ok( load_class('Business::PaperlessTrans::Client') => [{
		debug => $ENV{PERL_BUSINESS_BACKOFFICE_DEBUG},
	}]);

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

my $check
	= new_ok( load_class( $prefix . 'Check') => [{
		routing_number  => 111111118,
		account_number  => 12121214,
		name_on_account => 'Richard Simões',
		address         => $address,
	}]);


my $req
	= new_ok( load_class( $req_prefix . '::ProcessACH' ) => [{
		amount       => 4.22,
		currency     => 'USD',
		check_number => '022',
		check        => $check,
		test         => 1,
		token        => $token,
	}]);

method_ok $req, type => [], 'ProcessACH';

my $res = $client->submit( $req );

isa_ok $res, 'Business::PaperlessTrans::Response::ProcessACH';

method_ok $res, is_accepted => [], 1;
method_ok $res, code        => [], 0;
method_ok $res, message     => [], '';

done_testing;
