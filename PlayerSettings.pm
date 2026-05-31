package Plugins::DynamicMix::PlayerSettings;

use strict;
use base qw(Slim::Web::Settings);
use Plugins::DynamicMix::Plugin;
use Slim::Utils::Prefs;
use Slim::Utils::Log;
use Slim::Utils::DateTime;
use LWP::UserAgent;

my $port = preferences('plugin.musicip')->get('port');

my $prefs = preferences('plugin.DynamicMix');

my $log = Slim::Utils::Log->addLogCategory({
	'category'     => 'plugin.DynamicMix',
	'defaultLevel' => 'DEBUG',
	'description'  => 'PLUGIN_DYNAMICMIX',
});

sub getDisplayName {
	return 'PLUGIN_DYNAMICMIX';
}

sub needsClient {
	return 1;
}

sub name {
	return Slim::Web::HTTP::CSRF->protectName('PLUGIN_DYNAMICMIX');
}

sub page {
	return Slim::Web::HTTP::CSRF->protectURI('plugins/DynamicMix/settings/player.html');
}

sub prefs {
	my ($class, $client) = @_;
	return ($prefs->client($client), qw(style variety restrictgenre recipe filter maxremembertracks ));
}

sub handler {
	my ($class, $client, $params, $callback, @args) = @_;

	if ($params->{'saveSettings'})
	{
		# Save form data to prefs

		my $style = $params->{'pref_style'};
		$prefs->client($client)->set('style', "$style");

		my $variety = $params->{'pref_variety'};
		$prefs->client($client)->set('variety', "$variety");

		my $restrictgenre = $params->{'pref_restrictgenre'} || 0;
		$prefs->client($client)->set('restrictgenre', "$restrictgenre");

		my $recipe = $params->{'pref_recipe'};
		$prefs->client($client)->set('recipe', "$recipe");

		my $filter = $params->{'pref_filter'};
		$prefs->client($client)->set('filter', "$filter");

		my $maxremembertracks = $params->{'pref_maxremembertracks'};
		$prefs->client($client)->set('maxremembertracks', "$maxremembertracks");
	}

	$params->{'prefs'}->{'style'} = $prefs->client($client)->get('style');
	$params->{'prefs'}->{'variety'} = $prefs->client($client)->get('variety');
	$params->{'prefs'}->{'restrictgenre'}  = $prefs->client($client)->get('restrictgenre');
	$params->{'prefs'}->{'recipe'} = $prefs->client($client)->get('recipe');
	$params->{'prefs'}->{'filter'} = $prefs->client($client)->get('filter');
	$params->{'prefs'}->{'maxremembertracks'} = $prefs->client($client)->get('maxremembertracks');
	$params->{'recipes'} = getRecipesList();
	$params->{'filters'} = getFilterList();

	return $class->SUPER::handler($client, $params);
}

sub getPrefs {
	return $prefs;
}

sub getFilterList {
	my @filters = ();

	my $url = "http://localhost:$port/api/filters";
	my $ua = LWP::UserAgent->new();
	my $http = $ua->get($url);		

	push @filters, "";
	if ($http) {
		push @filters, split(/\n/, $http->content);
	}

	return \@filters;	
}

sub getRecipesList {
	my @recipes = ();

	my $url = "http://localhost:$port/api/recipes";
	my $ua = LWP::UserAgent->new();
	my $http = $ua->get($url);		

	push @recipes, "";
	if ($http) {
		push @recipes, split(/\n/, $http->content);
	}

	return \@recipes;
}

1;

__END__
