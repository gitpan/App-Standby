
use strict;
use warnings;

use 5.010_000;

use ExtUtils::MakeMaker 6.30;

use File::ShareDir::Install;
install_share dist => "share";


my %WriteMakefileArgs = (
  "ABSTRACT" => "Managing on-call rotation and notification queues",
  "AUTHOR" => "Dominik Schulz <dominik.schulz\@gauner.org>",
  "BUILD_REQUIRES" => {
    "File::Temp" => 0,
    "HTTP::Request::Common" => 0,
    "Plack::Test" => 0,
    "Test::MockObject::Universal" => 0,
    "Test::More" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30",
    "File::ShareDir::Install" => "0.03"
  },
  "DISTNAME" => "App-Standby",
  "EXE_FILES" => [
    "bin/standby-mgm.pl",
    "bin/standby-mgm.psgi",
    "bin/standby-mgm-cgi.pl"
  ],
  "LICENSE" => "perl",
  "NAME" => "App::Standby",
  "PREREQ_PM" => {
    "Config::Yak" => 0,
    "Config::Yak::RequiredConfig" => 0,
    "DBI" => 0,
    "Data::Pwgen" => 0,
    "File::ShareDir" => 0,
    "JSON" => 0,
    "LWP::UserAgent" => 0,
    "List::Util" => 0,
    "Log::Tree" => 0,
    "Log::Tree::RequiredLogger" => 0,
    "Module::Pluggable" => 0,
    "Moose" => 0,
    "MooseX::App::Cmd" => 0,
    "MooseX::App::Cmd::Command" => 0,
    "Pingdom::Client" => 0,
    "Plack::Builder" => 0,
    "Plack::Loader" => 0,
    "Plack::Request" => 0,
    "Template" => 0,
    "Try::Tiny" => 0,
    "URI::Escape" => 0,
    "feature" => 0,
    "mro" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.01",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

{
package
MY;
use File::ShareDir::Install qw(postamble);
}


