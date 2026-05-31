package Plugins::DynamicMix::Settings;

use strict;
use base qw(Slim::Web::Settings);
use Slim::Utils::Prefs;

my $prefs = preferences('plugin.DynamicMix');

# Changes below for 7.4 compliance

sub name {
	return Slim::Web::HTTP::CSRF->protectName('PLUGIN_DYNAMICMIX');
}

sub page {
	return Slim::Web::HTTP::CSRF->protectURI('plugins/DynamicMix/settings/basic.html');
}

sub handler {
	my ($class, $client, $params) = @_;
	if ($params->{'saveSettings'})
	{
		# No settings in here yet...
	}
	
	return $class->SUPER::handler($client, $params);
}
1;

__END__
